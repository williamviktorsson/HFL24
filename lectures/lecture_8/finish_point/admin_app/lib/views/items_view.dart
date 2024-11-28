import 'package:client_repositories/async_http_repos.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared_widgets/shared_widgets.dart';

class ItemsView extends StatefulWidget {
  ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  Future<List<Item>> getItems = ItemRepository().getAll();

  int _selectedIndex = -1;
  Item? selectedItem = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit items page"),
      ),
      body: FutureBuilder<List<Item>>(
        future: getItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return ListTile(
                    selectedTileColor: Colors.blueAccent,
                    selected: index == _selectedIndex,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        selectedItem = item;
                      });
                    },
                    title: Text(item.description),
                  );
                });
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      ),
      // add gap to row items
      floatingActionButton: AnimatedActionButtons(
        selectedItem: selectedItem,
        onClear: () {
          setState(() {
            _selectedIndex = -1;
            selectedItem = null;
          });
        },
        onItemCreated: (item) async {
          await ItemRepository().create(item);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Item ${item.description} created"),
              ),
            );
          }

          setState(() {
            getItems = ItemRepository().getAll();
          });
        },
        onItemEdited: (item) async {
          await ItemRepository().update(item.id, item);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Item ${item.description} updated"),
              ),
            );
          }

          setState(() {
            getItems = ItemRepository().getAll();
          });
        },
        onItemDeleted: (item) async {
          await ItemRepository().delete(item.id);

          _selectedIndex=-1;
          selectedItem = null;

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Item ${item.description} deleted"),
              ),
            );
          }

          setState(() {
            getItems = ItemRepository().getAll();
          });
        },
      ),
    );
  }
}

class ItemActionsWidget extends StatelessWidget {
  const ItemActionsWidget(
      {super.key, required this.item, required this.callback});

  final Item item;

  final Function() callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.deepOrange,
      child: OverflowBar(
        children: [
          TextButton(onPressed: () => {}, child: const Text("Edit")),
          TextButton(onPressed: () => {}, child: const Text("Delete")),
          TextButton(onPressed: callback, child: const Text("Clear selection"))
        ],
      ),
    );
  }
}

class AnimatedActionButtons extends StatelessWidget {
  final Item? selectedItem;
  final VoidCallback onClear;
  final Function(Item item) onItemCreated;
  final Function(Item item) onItemEdited;
  final Function(Item item) onItemDeleted;

  const AnimatedActionButtons({
    required this.selectedItem,
    required this.onClear,
    required this.onItemCreated,
    super.key,
    required this.onItemEdited,
    required this.onItemDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return OverflowBar(
      alignment: MainAxisAlignment.end,
      spacing: 8,
      children: [
        AnimatedSize(
          alignment: Alignment.centerRight,
          duration: const Duration(milliseconds: 200),
          child: selectedItem != null
              ? FloatingActionButton(
                  onPressed: () async {
                    var item = await editItemDialog(context, selectedItem!);

                    if (item != null) {
                      // show snackbar showing item description success message

                      onItemEdited(item);
                    }
                  },
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
                  onPressed: () {
                    onItemDeleted(selectedItem!);
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
                  label: const Text("Clear selection"),
                  onPressed: onClear,
                )
              : FloatingActionButton.extended(
                  label: const Text("Add item"),
                  onPressed: () async {
                    var item = await createItemDialog(context);

                    if (item != null) {
                      // show snackbar showing item description success message

                      onItemCreated(item);
                    }
                  },
                ),
        ),
      ],
    );
  }

  Future<Item?> createItemDialog(BuildContext context) {
    return showModalBottomSheet<Item>(
        context: context,
        builder: (context) {
          String? description;

          final key = GlobalKey<FormState>();

          final focusNode = FocusNode();

          save() {
            if (key.currentState!.validate()) {
              key.currentState!.save();
              Navigator.of(context).pop(Item(description!));
            }
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Create new item",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Divider(),
              Expanded(
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration:
                            InputDecoration(hintText: "Enter item description"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a description";
                          }
                          return null;
                        },
                        onSaved: (value) => description = value,
                        onFieldSubmitted: (value) {
                          save();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              OverflowBar(spacing: 8, children: [
                FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                FilledButton(
                  onPressed: () {
                    save();
                  },
                  child: Text("Create"),
                )
              ]),
            ]),
          );
        });
  }
}

Future<Item?> editItemDialog(BuildContext context, Item item) {
  return showModalBottomSheet<Item>(
      context: context,
      builder: (context) {
        String? description = item.description;

        final key = GlobalKey<FormState>();

        save() {
          if (key.currentState!.validate()) {
            key.currentState!.save();

            Navigator.of(context).pop(Item(description!, item.id));
          }
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Create new item",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Expanded(
              child: Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: item.description,
                      autofocus: true,
                      decoration:
                          InputDecoration(hintText: "Enter item description"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a description";
                        }
                        return null;
                      },
                      onSaved: (value) => description = value,
                      onFieldSubmitted: (value) {
                        save();
                      },
                    ),
                  ],
                ),
              ),
            ),
            OverflowBar(spacing: 8, children: [
              FilledButton.tonal(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FilledButton(
                onPressed: () {
                  save();
                },
                child: Text("Create"),
              )
            ]),
          ]),
        );
      });
}
