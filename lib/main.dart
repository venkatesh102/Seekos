import '../Screens/botttomnavigationbatpage.dart';
// import '../Screens/chat_screen.dart';
import '../Screens/homescreen.dart';
import '../Screens/pendingverificationpage.dart';
import '../Screens/productsdetailspage.dart';
import '../Screens/profile.dart';
import '../Screens/sell_subcategory_selectpage.dart';
import '../Screens/sellerregistrationpage.dart';
import '../auth_screens/forgotpassword.dart';
import '../auth_screens/identityverification.dart';
import '../Screens/category.dart';
import '../auth_screens/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/allproductspage.dart';
import 'Screens/sell_categories_selectpage.dart';
import 'Screens/subcategories.dart';
import 'auth_screens/emailverification.dart';
import 'auth_screens/registrationpage.dart';
import 'auth_screens/splashscreen.dart';
import 'package:provider/provider.dart';
import '../Screens/seeall.dart';
import 'methods/providerclass.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType=null;
  runApp(MultiProvider(providers: [Provider(create: (_)=>ProductProvider()),Provider(create: (_)=>CategoryProvider())],child:
      MaterialApp(debugShowCheckedModeBanner:false,home: MyApp()))
  );
}
void Message(BuildContext context,String message)
{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 5),
    action: SnackBarAction(
      label: 'ACTION',
      onPressed: () { },
    ),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // static const String id='loginpage';
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(future: Future.delayed(Duration(seconds: 6)),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              return MaterialApp(debugShowCheckedModeBanner: false,
                  home:BottomNavigationBarPage(),
                  routes: {
                    RegistrationPage.id: (context) => RegistrationPage(),
                    Categories.id: (context) => Categories(),
                    ForgetPassword.id: (context) => ForgetPassword(),
                    PendingVerification.id: (context) => PendingVerification(),
                    LivePhotoAuth.id: (context) => LivePhotoAuth(),
                    HomeScreen.id: (context) => HomeScreen(),
                    SeeAll.id: (context) => SeeAll(),
                    SubCategories.id: (context) => SubCategories(),
                    Profile.id: (context) => Profile(),
                    VerifyEmailPage.id: (context) => VerifyEmailPage(),
                    BottomNavigationBarPage.id: (context) =>
                        BottomNavigationBarPage(),
                    SellCategoriesSelectPage.id: (context) =>
                        SellCategoriesSelectPage(),
                    SellSubCategoriesSelectPage.id: (context) =>
                        SellSubCategoriesSelectPage(),
                    SellerRegistration.id: (context) => SellerRegistration(),
                    AllProducts.id: (context) => AllProducts(),
                    ProductDetailsPage.id: (context) => ProductDetailsPage(),
                  });
            }));
  }
}





