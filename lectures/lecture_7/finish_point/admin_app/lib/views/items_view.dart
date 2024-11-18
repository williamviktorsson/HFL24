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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit items page"),
      ),
      body: FutureBuilder<List<Item>>(
        future: getItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ItemWidget(
                    item: snapshot.data![index],
                  );
                });
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            // show dialog to create new item and confirm

            var result = await showDialog<String>(
                context: context,
                builder: (context) {
                  TextEditingController controller = TextEditingController();

                  return AlertDialog(
                    title: Text("Create new item"),
                    content: TextField(
                      focusNode: FocusNode(),
                      controller: controller,
                      decoration:
                          InputDecoration(hintText: "Enter item description"),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Failed to provide description")));
                            } else {
                              Navigator.of(context).pop(controller.text);
                            }
                          },
                          child: Text("Create")),
                    ],
                  );
                });

            if (result != null) {
              await ItemRepository().create(Item(result));
            }

            setState(() {
              getItems = ItemRepository().getAll();
            });
          },
          label: Text("Create new item")),
    );
  }
}
