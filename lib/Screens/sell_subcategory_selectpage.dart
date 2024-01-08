import 'package:seekos/Screens/pendingverificationpage.dart';
import 'package:seekos/Screens/sellerregistrationpage.dart';
import 'package:seekos/methods/providerclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../methods/appconstants.dart';

class SellSubCategoriesSelectPage extends StatefulWidget {
  static const String id = 'sellsubcategories';
  @override
  State<SellSubCategoriesSelectPage> createState() => _SellSubCategoriesSelectPageState();
}

class _SellSubCategoriesSelectPageState extends State<SellSubCategoriesSelectPage> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var _provider=Provider.of<CategoryProvider>(context);

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
                      return Column(
                        children: [
                          OutlinedButton(
                          onPressed: (){Navigator.pushNamed(context,SellerRegistration.id);
                      _provider.getSelectedSubCat(data[index]);
                      },
                            child: ListTile(
                              visualDensity: VisualDensity.standard,
                                title: Text(
                                  data[index],
                                )),
                          ),
                          // Divider(endIndent:0,thickness: 0.1,color: Colors.black,),

                        ],
                      );
                    },
                  ),
                );
              }),
        ));
  }
}
