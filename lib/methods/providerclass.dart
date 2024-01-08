import '../methods/appconstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  FirebaseServices _services=FirebaseServices();
  late DocumentSnapshot doc;
  late DocumentSnapshot userDetails;
  late String selectedCategory;
   late String selectedSubCategory;
  List<String> ImageUrlList=[];
  var selectedImages=0;
  Map<String,dynamic> dataToFirestore={};
  getCategory(selectedCat) {
    this.selectedCategory = selectedCat;
    notifyListeners();
  }
  getCatSnapshot(snapshot) {
    this.doc = snapshot;
    notifyListeners();
  }
  getImageUrl(url)
  {
    this.ImageUrlList.add(url);
    notifyListeners();
  }
  getData(data){
    this.dataToFirestore=data;
     notifyListeners();
  }
  getSelectedSubCat(selectedsubcat)
  {
    this.selectedSubCategory=selectedsubcat;
    notifyListeners();
  }
  getSelectedImages(selectedimages)
  {
    this.selectedImages=selectedimages;
    notifyListeners();
  }
  getUserDetails()
  {
    _services.getUserData().then((value){
      this.userDetails=value;
      notifyListeners();
    });
  }

}

class ProductProvider extends ChangeNotifier {
  late DocumentSnapshot ProductDetails;
  late String sellerDetails;
  getProductDetails(details)
  {
    this.ProductDetails=details;
    notifyListeners();
  }
  getSellerDetails(details) {
    this.sellerDetails = details;
    notifyListeners();
  }

}