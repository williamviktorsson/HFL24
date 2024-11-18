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
                  return ListTile(
                    title: Text(snapshot.data![index].description),
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
                  return AlertDialog(
                    title: Text("Create new item"),
                    content: TextField(
                      decoration:
                          InputDecoration(hintText: "Enter item description"),
                      onSubmitted: (value) {
                        Navigator.of(context).pop(value);
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"))
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
