import 'package:client_repositories/async_http_repos.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ItemsView extends StatefulWidget {
  ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  Future<List<Item>> getItems = ItemRepository().getAll();

  int _selectedIndex = -1;
  Item? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Item>>(
          future: getItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  // TODO #2: Add PageStorageKey to ListView.builder for scroll position preservation

                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data![index];
                    return Hero(
                      tag: item.id,
                      child: Material(
                        child: ListTile(
                          selected: index == _selectedIndex,
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                              selectedItem = item;
                            });
                          },
                          title: Text(item.description),
                        ),
                      ),
                    );
                  });
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
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

          _selectedIndex = -1;
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
                  heroTag: "edit_item",
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
                  heroTag: "delete_item",
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
                  heroTag: "clear_selection",
                  label: const Text("Clear selection"),
                  onPressed: onClear,
                )
              : FloatingActionButton.extended(
                  heroTag: "add_item",
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
    // TODO #8: Create CustomPageRoute for edit dialog
    // - Replace MaterialPageRoute with CustomPageRoute
    // - Add rotation and scale transitions
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
  return Navigator.of(context).push<Item>(
      CustomPageRouteBuilder<Item>(child: Builder(builder: (context) {
    String? description = item.description;

    final key = GlobalKey<FormState>();

    save() {
      if (key.currentState!.validate()) {
        key.currentState!.save();

        Navigator.of(context).pop(Item(description!, item.id));
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            tag: item.id,
            child: AppBar(
              automaticallyImplyLeading: false,
              title: Text(item.description),
              // No need to specify styles here anymore
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Form(
              key: key,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: item.description,
                    autofocus: true,
                    // add tooltip to description field
                    decoration: InputDecoration(
                        hintText: "Enter item description",
                        labelText: "Description"),
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
      ),
    );
  })));
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

            return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child));
          },
        );
}


// se om det finns något enhetligare sätt att göra theming på
























































/* 

import 'package:client_repositories/async_http_repos.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  Future<List<Item>> getItems = ItemRepository().getAll();

  int _selectedIndex = -1;
  Item? selectedItem;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (context) {
        return Scaffold(
          key: GlobalKey(),

          body: FutureBuilder<List<Item>>(
            future: getItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return ListView.builder(
                        key: const PageStorageKey('uniqueItemsListViewKey'),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data![index];
                          // Usage in your ItemsView ListTile:
                          return Hero(
                            tag: item.id,
                            child: Material(
                              type: MaterialType.transparency,
                              child: ListTile(
                                // No need to specify colors here anymore
                                selected: index == _selectedIndex,
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                    selectedItem = item;
                                  });
                                },
                                title: Text(item.description),
                              ),
                            ),
                          );
                        });
                  }
                );
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

              _selectedIndex = -1;
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
      }),
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
                  heroTag: "edit",
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
                  heroTag: "delete",
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
                  heroTag: "clear",
                  label: const Text("Clear selection"),
                  onPressed: onClear,
                )
              : FloatingActionButton.extended(
                  heroTag: "add",
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
              const Text(
                "Create new item",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration: const InputDecoration(
                            hintText: "Enter item description"),
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
                    child: const Text("Cancel")),
                FilledButton(
                  onPressed: () {
                    save();
                  },
                  child: const Text("Create"),
                )
              ]),
            ]),
          );
        });
  }
}

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  CustomPageRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 2000),
          reverseTransitionDuration: const Duration(milliseconds: 2000),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            /* rotate transition spin */
            final rotateTween = Tween<double>(begin: 0, end: 1);
            final rotateAnimation = rotateTween.animate(animation);

            return ScaleTransition(
              scale: animation,
              child: RotationTransition(
                turns: rotateAnimation,
                child: child,
              ),
            );
          },
        );
}

Future<Item?> editItemDialog(BuildContext context, Item item) {
  return Navigator.of(context)
      .push<Item>(CustomPageRoute<Item>(child: Builder(builder: (context) {
    String? description = item.description;

    final key = GlobalKey<FormState>();

    save() {
      if (key.currentState!.validate()) {
        key.currentState!.save();

        Navigator.of(context).pop(Item(description!, item.id));
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            tag: item.id,
            child: AppBar(
              automaticallyImplyLeading: false,
              title: Text(item.description),
              // No need to specify styles here anymore
            ),
          ),
          Expanded(
            child: Form(
              key: key,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: item.description,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText: "Enter item description"),
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
                child: const Text("Cancel")),
            FilledButton(
              onPressed: () {
                save();
              },
              child: const Text("Create"),
            )
          ]),
        ]),
      ),
    );
  })));
}


 */