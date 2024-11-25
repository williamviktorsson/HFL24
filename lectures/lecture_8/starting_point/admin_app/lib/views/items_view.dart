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
        selectedIndex: _selectedIndex,
        onClear: () {
          setState(() {
            _selectedIndex = -1;
            selectedItem = null;
          });
        },
        onItemCreated: (item) async {
          await ItemRepository().create(item);
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
  final int selectedIndex;
  final VoidCallback onClear;
  final Function(Item item) onItemCreated;

  const AnimatedActionButtons({
    required this.selectedIndex,
    required this.onClear,
    required this.onItemCreated,
    super.key,
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
          child: selectedIndex != -1
              ? FloatingActionButton(
                  onPressed: () {
                    // edit item
                  },
                  child: const Icon(Icons.edit),
                )
              : const SizedBox.shrink(),
        ),
        AnimatedSize(
          alignment: Alignment.centerRight,
          duration: const Duration(milliseconds: 200),
          reverseDuration: const Duration(milliseconds: 200),
          child: selectedIndex != -1
              ? FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.delete),
                )
              : const SizedBox.shrink(),
        ),
        AnimatedSize(
          alignment: Alignment.centerRight,
          duration: const Duration(milliseconds: 200),
          child: selectedIndex != -1
              ? FloatingActionButton.extended(
                  label: const Text("Clear selection"),
                  onPressed: onClear,
                )
              : FloatingActionButton.extended(
                  label: const Text("Add item"),
                  onPressed: () async {
                    var result = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController();

                          return AlertDialog(
                            title: Text("Create new item"),
                            content: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                  hintText: "Enter item description"),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel")),
                              TextButton(
                                  onPressed: () {
                                    if (controller.text.length < 1) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Failed to provide description")));
                                    } else {
                                      Navigator.of(context)
                                          .pop(controller.text);
                                    }
                                  },
                                  child: Text("Create")),
                            ],
                          );
                        });

                    if (result != null) {
                      onItemCreated(Item(result));
                    }
                  },
                ),
        ),
      ],
    );
  }
}
