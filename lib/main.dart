import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/login_page/login.dart';
import 'package:todo/auth/register_page/register.dart';
import 'package:todo/home/tasklist/edit_task_screen.dart';
import 'package:todo/mytheme.dart';
import 'package:todo/provider/app_config_provider.dart';
import 'package:todo/provider/auth_provider.dart';

import 'home/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseFirestore.instance.disableNetwork();
  //FirebaseFirestore.instance.settings =
  //Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppConfigProvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        EditTaskScreen.routeName: (context) => EditTaskScreen()
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.appLanguage),
      theme: MyTheme.LightMode,
      darkTheme: MyTheme.DarkMode,
      themeMode: provider.appTheme,
    );
  }
}
