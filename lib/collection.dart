import 'package:flutter/material.dart';
import 'package:quotes/view/album.dart';
import 'package:quotes/database.dart';
import 'package:quotes/utils.dart';

class collectionScreen extends StatefulWidget {
  const collectionScreen({super.key});

  @override
  State<collectionScreen> createState() => _collectionScreenState();
}

class _collectionScreenState extends State<collectionScreen> {
  Future<List<Collection>>? future;

  @override
  void initState() {
    future = DBHelper.getCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Collection"),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AlbumScreen(collectionName: snapshot.data?[index].name),
                ));
              },
              title: Text("${snapshot.data?[index].name}"),
              subtitle: Text("${snapshot.data?[index].id}"),
            ),
          );
        },
      ),
    );
  }
}
