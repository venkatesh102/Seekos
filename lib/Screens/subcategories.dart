import '../Screens/pendingverificationpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../methods/appconstants.dart';

class SubCategories extends StatefulWidget {
  static const String id = 'subcategories';
  @override
  State<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot? args = ModalRoute.of(context)!.settings.arguments
    as DocumentSnapshot<Object?>?;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(colour),
          title: Text(args!['CatName']),
        ),
        body: Container(
          child: FutureBuilder<DocumentSnapshot>(
              future: _services.categories.doc(args.id).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data!['subCat'];
                return Container(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(
                            data[index],
                          ));
                    },
                  ),
                );
              }),
        ));
  }
}