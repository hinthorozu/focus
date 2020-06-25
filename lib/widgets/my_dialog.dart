import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:focus/config/my_colors.dart';
import 'package:focus/widgets/my_text.dart';
import 'package:flutter/material.dart';

class MyDialog extends StatefulWidget {
  final bool is25Minute;
  MyDialog({Key key, @required this.is25Minute}) : super(key: key);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool is25Minute = false;
  static AudioCache cache = new AudioCache();
  static AudioPlayer player = AudioPlayer();
  void _playFile(String pomodorobreakStart) async {
    player = await cache.loop(pomodorobreakStart); // assign player here
  }

  @override
  Widget build(BuildContext context) {
    is25Minute = widget.is25Minute;
    _playFile(is25Minute
        ? "sound/pomodoro_break_start.mp3"
        : "sound/pomodoro_break_finish.mp3");
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                color: is25Minute
                    ? Color(0xFFfdd55c)
                    : Theme.of(context).primaryColor,
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    Icon(Icons.verified_user, color: Colors.white, size: 80),
                    Container(height: 10),
                    Text(is25Minute ? "Biraz Dinlenme Zamanı" : "Konsantre Ol!",
                        style: MyText.title(context)
                            .copyWith(color: Colors.white)),
                    Container(height: 10),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      child: Text(
                        is25Minute ? "Bunu Hakettin :) " : "Devam Et",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: is25Minute
                          ? MyColors.yellowOwn
                          : Theme.of(context).primaryColor,
                      onPressed: () {
                        player?.stop();
                        Navigator.pop(context, is25Minute ? false : true);
                      },
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
