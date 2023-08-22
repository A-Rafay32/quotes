import 'package:flutter/material.dart';

import '../../../res/constants.dart';

class UserCollectionScreen extends StatelessWidget {
  const UserCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("User Collection",
            style: TextStyle(
                fontSize: 28, fontFamily: "Ramaraja", color: Colors.white)),
      ),
      // body: ,
    );
  }
}
