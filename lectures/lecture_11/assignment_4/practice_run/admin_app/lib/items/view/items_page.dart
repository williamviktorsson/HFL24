import 'package:admin_app/items/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemsBloc, ItemsState>(
      listenWhen: (previous, current) => current is ItemsError,
      listener: (context, state) {
        if (state is ItemsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<ItemsBloc, ItemsState>(
            builder: (context, state) => switch (state) {
              ItemsInitial() => const InitialView(),
              ItemsLoading() => const CircularProgressIndicator(),
              ItemsError() => ErrorView(message: state.message),
              ItemsReloading(items: final items) ||
              ItemsLoaded(items: final items) =>
                ItemsList(
                  items: items,
                ),
            },
          ),
        ),
        floatingActionButton: const AnimatedActionButtons(),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error: $message'),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => context.read<ItemsBloc>().add(const LoadItems()),
          child: const Text('Retry'),
        ),
      ],
    );
  }
}

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton(
          onPressed: () => context.read<ItemsBloc>().add(const LoadItems()),
          child: const Text('Press to load items'),
        ),
      ],
    );
  }
}

class ItemsList extends StatelessWidget {
  final List<Item> items;

  const ItemsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ItemsBloc>().add(const ReloadItems());
        // await itemsbloc emits loaded state

        await context
            .read<ItemsBloc>()
            .stream
            .firstWhere((state) => state is ItemsLoaded);
      },
      child: ListView.builder(
        // scrollable on desktop
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return BlocBuilder<ItemsBloc, ItemsState>(
              buildWhen: (previous, current) =>
                  current is ItemsReloading &&
                  current.changedItem?.id == item.id,
              builder: (context, itemsState) {
                return BlocBuilder<SelectionCubit, Item?>(
                  builder: (context, selectedItem) {
                    final isSelected = selectedItem?.id == item.id;
                    final isUpdating = itemsState is ItemsReloading &&
                        itemsState.changedItem?.id == item.id;
                    return Hero(
                      tag: item.id,
                      child: Material(
                        child: ListTile(
                          selected: isSelected,
                          enabled: !isUpdating,
                          trailing: isUpdating
                              ? const CircularProgressIndicator()
                              : null,
                          onTap: () {
                            context.read<SelectionCubit>().selectItem(
                                  isSelected ? null : item,
                                );
                          },
                          title: Text(item.description),
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}

class AnimatedActionButtons extends StatelessWidget {
  const AnimatedActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, Item?>(
      builder: (context, selectedItem) {
        return OverflowBar(
          alignment: MainAxisAlignment.end,
          spacing: 8,
          children: [
            AnimatedSize(
              alignment: Alignment.centerRight,
              duration: const Duration(milliseconds: 200),
              child: selectedItem != null
                  ? FloatingActionButton(
                      heroTag: "edit_item",
                      onPressed: () => _editItem(context, selectedItem),
                      child: const Icon(Icons.edit),
                    )
                  : const SizedBox.shrink(),
            ),
            AnimatedSize(
              alignment: Alignment.centerRight,
              duration: const Duration(milliseconds: 200),
              reverseDuration: const Duration(milliseconds: 200),
              child: selectedItem != null
                  ? FloatingActionButton(
                      heroTag: "delete_item",
                      onPressed: () {
                        context.read<ItemsBloc>().add(DeleteItem(selectedItem));
                        context.read<SelectionCubit>().clearSelection();
                      },
                      child: const Icon(Icons.delete),
                    )
                  : const SizedBox.shrink(),
            ),
            AnimatedSize(
              alignment: Alignment.centerRight,
              duration: const Duration(milliseconds: 200),
              child: selectedItem != null
                  ? FloatingActionButton.extended(
                      heroTag: "clear_selection",
                      label: const Text("Clear selection"),
                      onPressed: () =>
                          context.read<SelectionCubit>().clearSelection(),
                    )
                  : FloatingActionButton.extended(
                      heroTag: "add_item",
                      label: const Text("Add item"),
                      onPressed: () => _createItem(context),
                    ),
            ),
            FloatingActionButton(
              heroTag: "undo",
              onPressed: () {
                context.read<SelectionCubit>().undo();
              },
              child: const Icon(Icons.undo),
            ),
            FloatingActionButton(
              heroTag: "redo",
              onPressed: () {
                context.read<SelectionCubit>().redo();
              },
              child: const Icon(Icons.redo),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createItem(BuildContext context) async {
    final item = await showModalBottomSheet<Item>(
      context: context,
      builder: (context) => const CreateItemForm(),
    );

    if (item != null && context.mounted) {
      context.read<ItemsBloc>().add(CreateItem(item));
    }
  }

  Future<void> _editItem(BuildContext context, Item item) async {
    final updatedItem = await Navigator.of(context).push<Item>(
      CustomPageRouteBuilder<Item>(
        child: EditItemForm(item: item),
      ),
    );

    if (updatedItem != null && context.mounted) {
      context.read<ItemsBloc>().add(UpdateItem(updatedItem));
      context.read<SelectionCubit>().selectItem(updatedItem);
    }
  }
}

class CreateItemForm extends StatefulWidget {
  const CreateItemForm({super.key});

  @override
  State<CreateItemForm> createState() => _CreateItemFormState();
}

class _CreateItemFormState extends State<CreateItemForm> {
  final _formKey = GlobalKey<FormState>();
  String? _description;

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(Item(_description!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create new item",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Enter item description",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a description";
                      }
                      return null;
                    },
                    onSaved: (value) => _description = value,
                    onFieldSubmitted: (_) => _save(),
                  ),
                ],
              ),
            ),
          ),
          OverflowBar(
            spacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: _save,
                child: const Text("Create"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditItemForm extends StatefulWidget {
  final Item item;

  const EditItemForm({super.key, required this.item});

  @override
  State<EditItemForm> createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  final _formKey = GlobalKey<FormState>();
  String? _description;

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(Item(_description!, widget.item.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.item.id,
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Text(widget.item.description),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: widget.item.description,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "Enter item description",
                        labelText: "Description",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a description";
                        }
                        return null;
                      },
                      onSaved: (value) => _description = value,
                      onFieldSubmitted: (_) => _save(),
                    ),
                  ],
                ),
              ),
            ),
            OverflowBar(
              spacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                FilledButton(
                  onPressed: _save,
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPageRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget child;

  CustomPageRouteBuilder({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            /* rotate transition spin */
            final rotateTween = Tween<double>(begin: 0, end: 1);
            final rotateAnimation = rotateTween.animate(animation);

            return RotationTransition(
                turns: rotateAnimation,
                child: ScaleTransition(scale: animation, child: child));
          },
        );
}
