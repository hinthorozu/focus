import 'package:flutter/material.dart';
import 'package:focus/config/my_colors.dart';
import 'package:focus/widgets/drawer.dart';
import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController controller;
  int pomodoroMinute = 10;
  bool isPlaying = false;
  bool isPomodoro = false;
  Duration duration;
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final String pomodorobreakStart = "sound/pomodoro_break_start.mp3";
  static AudioCache cache = new AudioCache();
  static AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    controller = animationController(pomodoroMinute);
  }


  AnimationController animationController(int pomodoroMinute) {
    return AnimationController(
      vsync: this,
      duration: Duration(seconds: pomodoroMinute),
    );
  }

  String get timerString {
    duration = controller.duration * controller.value;
    if (duration.inMinutes == 0 && duration.inSeconds == 0) {
      isPlaying = false;
      onSelectNotification();
    }
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
  void _playFile() async {
    player = await cache.loop(pomodorobreakStart); // assign player here
  }

  onSelectNotification() {
    if (isPomodoro) {
      _playFile();
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text('Notification'),
          content: new Text('Desc'),
          actions: <Widget>[
            FlatButton(
              child: Text('Durdur'),
              onPressed: () {
                player?.stop();
              },
            ),
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
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
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, Widget child) {
                              return CustomPaint(
                                  painter: TimerPainter(
                                animation: controller,
                                backgroundColor: themeData.primaryColor,
                                color: Colors.redAccent,
                              ));
                            },
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              AnimatedBuilder(
                                  animation: controller,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Text(
                                      timerString,
                                      style: themeData.textTheme.headline1,
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) {
                          return FloatingActionButton.extended(
                              heroTag: "",
                              onPressed: () {
                                setState(() => isPlaying = !isPlaying);
                                if (controller.isAnimating)
                                  controller.stop(canceled: true);
                                else {
                                  controller.reverse(
                                      from: controller.value == 0.0
                                          ? 1.0
                                          : controller.value);
                                }
                              },
                              icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow),
                              label: Text(isPlaying ? "Durdur" : "Başlat"));
                        }),
                    FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            isPlaying = true;
                            controller = animationController(pomodoroMinute);
                            isPomodoro=true;
                          });
                          if (controller.isAnimating) {
                            controller.stop(canceled: true);
                          } else {
                            controller.reverse(
                                from: controller.value == 0.0
                                    ? 1.0
                                    : controller.value);
                          }
                        },
                        icon: Icon(Icons.refresh),
                        label: Text("Sıfırla")),
                    FloatingActionButton(
                      onPressed: () {
                        isPomodoro = true;
                        onSelectNotification();
                      },
                      child: Text("bas gitsin"),
                      heroTag: "denedde",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        drawer: buildDrawer(context));
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
