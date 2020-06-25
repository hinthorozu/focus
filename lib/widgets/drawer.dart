import 'package:focus/config/my_colors.dart';
import 'package:focus/config/my_string.dart';
import 'package:flutter/material.dart';
import 'package:focus/config/img.dart';
import 'package:focus/ui/about.dart';
import 'package:focus/utils/tools.dart';
import 'package:focus/widgets/my_text.dart';

Widget buildDrawer(BuildContext context) {
  // void onDrawerItemClicked(String name) {
  //   Navigator.pop(context);
  //   Toast.show(name + " Selected", context);
  // }

  return Drawer(
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 190,
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 50),
                      child: Image.asset(Img.get('logo_white.png'),
                          width: 60, height: 60),
                    ),
                    Container(height: 8),
                    Text(MyString.appName,
                        style: MyText.title(context).copyWith(
                          color: MyColors.yellowOwn,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ],
            ),
          ),
          Container(height: 8),
          ListTile(
            leading: Icon(Icons.star, size: 25.0, color: Colors.grey[600]),
            title: Text("Uygulamayı Puanla",
                style: MyText.subtitle1(context).copyWith(
                    color: Colors.grey[800], fontWeight: FontWeight.bold)),
            onTap: () {
              Tools.directUrl(
                  "https://play.google.com/store/apps/details?id=com.sdkport.focus");
            },
          ),
          Divider(),
          ListTile(
            title: Text("Hakkında",
                style: MyText.subtitle1(context).copyWith(
                    color: Colors.grey[800], fontWeight: FontWeight.bold)),
            leading: Icon(Icons.settings, size: 25.0, color: Colors.grey[600]),
            onTap: () {
              showDialog(context: context, builder: (_) => DialogAboutRoute());
            },
          ),
          ListTile(
            title: Text("Geri Bildirim",
                style: MyText.subtitle1(context).copyWith(
                    color: Colors.grey[800], fontWeight: FontWeight.bold)),
            leading:
                Icon(Icons.help_outline, size: 25.0, color: Colors.grey[600]),
            onTap: () {
              Tools.directUrl("http://sdkport.com");
            },
          ),
        ],
      ),
    ),
  );
}

Widget buildMenuDrawer(String title, Function onTap, BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      highlightColor: Colors.black.withOpacity(0.5),
      hoverColor: Colors.black.withOpacity(0.5),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        child: Text(title,
            style: MyText.subtitle1(context)
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    ),
  );
}
