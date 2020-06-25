import 'dart:async';
import 'package:focus/widgets/my_dialog.dart';
import 'package:flutter/material.dart';
import 'package:focus/config/my_colors.dart';
import 'package:focus/widgets/drawer.dart';
import 'package:screen/screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

  bool isPlaying = false;
  bool is25Minute = true;
  Timer _timer;
  int min_25 = 1500;
  int min_5 = 300;

  int _start;

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }
    return "$hoursStr:$minutesStr:$secondsStr";
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start < 1) {
          isPlaying = false;
          _start = is25Minute ? min_25 : min_5;
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => MyDialog(
                    is25Minute: is25Minute,
                  )).then((value) {
            setState(() {
              // Show dialogda geri dönen değere göre sıradaki işlemi yapıyorum.
              is25Minute = value;
              _start = value ? min_25 : min_5;
              isPlaying = true;
            });
          });
        } else {
          if (isPlaying) {
            _start = _start - 1;
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _start = is25Minute ? min_25 : min_5;
    startTimer();
    Screen.keepOn(true);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
        backgroundColor: themeData.canvasColor,
        key: _scaffoldStateKey,
        appBar: AppBar(
          title: Text(
            "Konsantre Ol Başla!",
          ),
          leading: IconButton(
            icon: Icon(Icons.menu, color: MyColors.grey_10),
            onPressed: () {
              if (_scaffoldStateKey.currentState.isDrawerOpen) {
                _scaffoldStateKey.currentState.openEndDrawer();
              } else {
                _scaffoldStateKey.currentState.openDrawer();
              }
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: FractionalOffset.center,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                formatHHMMSS(_start),
                                style: TextStyle(
                                    color: !is25Minute
                                        ? MyColors.yellowOwn
                                        : Theme.of(context).primaryColor,
                                    fontSize: 96.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: "",
                      onPressed: () {
                        setState(() => isPlaying = !isPlaying);
                      },
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(isPlaying ? "Durdur" : "Başlat"),
                    ),
                    FloatingActionButton.extended(
                      heroTag: "te",
                      onPressed: () {
                        setState(() => is25Minute = !is25Minute);
                        setState(() {
                          isPlaying = false;
                          _start = is25Minute ? min_25 : min_5;
                        });
                      },
                      label: Text(is25Minute ? "5 Dakika" : "25 Dakika"),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            isPlaying = false;
                            _start = is25Minute ? min_25 : min_5;
                          });
                        },
                        icon: Icon(Icons.refresh),
                        label: Text("Sıfırla")),
                  ],
                ),
              )
            ],
          ),
        ),
        drawer: buildDrawer(context));
  }
}
