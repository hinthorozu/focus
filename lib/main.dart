import 'dart:async';
import 'package:focus/config/img.dart';
import 'package:focus/config/my_string.dart';
import 'package:focus/config/my_theme.dart';
import 'package:focus/ui/home.dart';
import 'package:focus/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      home: SplashScreen(),
      routes: {
        '/home': (BuildContext context) => new HomePage(),
      }));

  SharedPreferences.getInstance().then((prefs) {
    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        home: SplashScreen(),
        routes: {
          '/home': (BuildContext context) => new HomePage(prefs: prefs),
        }));
  });
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void initState() {
    super.initState();
    // SQLiteDb dbHelper = SQLiteDb();
    // dbHelper.init();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: Container(
          width: 200,
          height: 150,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                child: Image.asset(Img.get('logo.png'), fit: BoxFit.cover),
              ),
              Container(height: 10),
              Text(MyString.appName,
                  style: MyText.headline(context).copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600)),
              Text(
                "SDK Port",
                style: MyText.body1(context).copyWith(color: Colors.grey[500]),
                maxLines: 3,
              ),
              Container(height: 20),
              Container(
                height: 5,
                width: 80,
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
