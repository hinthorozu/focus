import 'package:focus/config/my_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/config/img.dart';
import 'package:focus/config/my_colors.dart';
import 'package:focus/utils/tools.dart';
import 'package:focus/widgets/my_text.dart';
import 'package:package_info/package_info.dart';
import 'dart:io' show Platform;

class DialogAboutRoute extends StatefulWidget {
  DialogAboutRoute();

  @override
  DialogAboutRouteState createState() => new DialogAboutRouteState();
}

class DialogAboutRouteState extends State<DialogAboutRoute> {
  String version = "";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: MyColors.grey_20,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Image.asset(Img.get('logo.png'),
                          width: 60, height: 60),
                    ),
                    Container(height: 15),
                    Text(MyString.appName,
                        style: MyText.title(context).copyWith(
                            color: Colors.black, fontWeight: FontWeight.w500)),
                    Text("Versiyon " + version,
                        style:
                            MyText.body1(context).copyWith(color: Colors.grey)),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                        MyString.appDetail,
                        style: MyText.body1(context)
                            .copyWith(color: MyColors.grey_60),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 40,
                      child: FlatButton(
                        child: Text("Diğer Uygulamalar",
                            style: TextStyle(color: MyColors.accentDark)),
                        color: Colors.transparent,
                        onPressed: () {
                          Platform.isAndroid == true
                              ? Tools.directUrl(
                                  "https://play.google.com/store/apps/developer?id=SDK+Port")
                              : Tools.directUrl("https://google.com");
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: FlatButton(
                        child: Text("BİZE ULAŞIN",
                            style: MyText.bodyText1(context)
                                .copyWith(color: Colors.white)),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Tools.directUrl("http://sdkport.com");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
