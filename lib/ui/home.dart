import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/bloc/timer_bloc.dart';
import 'package:focus/config/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:focus/utils/ticker.dart';
import 'package:focus/widgets/drawer.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

int min_25 = 1500;
int min_5 = 300;

class HomePage extends StatefulWidget {
  final SharedPreferences prefs;
  HomePage({Key key, this.prefs}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    setState(() {
      widget.prefs.setInt('isMinute', 1500);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(
          ticker: Ticker(),
          duration: widget.prefs.getInt('isMinute') == 1500 ? min_25 : min_5),
      child: Scaffold(
        key: _scaffoldStateKey,
        appBar: AppBar(
          title: Text('Odaklan!'),
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
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.0),
                  child: Center(
                    child: BlocBuilder<TimerBloc, TimerState>(
                      builder: (context, state) {
                        final String minutesStr = ((state.duration / 60) % 60)
                            .floor()
                            .toString()
                            .padLeft(2, '0');
                        final String secondsStr = (state.duration % 60)
                            .floor()
                            .toString()
                            .padLeft(2, '0');
                        return Text(
                          '$minutesStr:$secondsStr',
                          style: TextStyle(
                              color: widget.prefs.getInt('isMinute') != 1500
                                  ? Theme.of(context).primaryColor
                                  : MyColors.yellowOwn,
                              fontSize: 96.0),
                        );
                      },
                    ),
                  ),
                ),
                BlocBuilder<TimerBloc, TimerState>(
                  condition: (previousState, state) =>
                      state.runtimeType != previousState.runtimeType,
                  builder: (context, state) => Actions(prefs: widget.prefs),
                ),
              ],
            ),
          ],
        ),
        drawer: buildDrawer(context),
      ),
    );
  }
}

class Actions extends StatefulWidget {
  final SharedPreferences prefs;
  Actions({Key key, @required this.prefs}) : super(key: key);
  @override
  _ActionsState createState() => _ActionsState();
}

class _ActionsState extends State<Actions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({TimerBloc timerBloc}) {
    final TimerState currentState = timerBloc.state;
    if (currentState is StateInitial) {
      return [
        FloatingActionButton(
            child: Icon(Icons.play_arrow),
            onPressed: () {
              timerBloc
                  .add(EventStarted(duration: widget.prefs.getInt('isMinute')));
            }),
      ];
    }
    if (currentState is StateRuning) {
      return [
        FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () => timerBloc.add(EventPaused()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc
              .add(EventReset(duration: widget.prefs.getInt('isMinute'))),
        ),
        FloatingActionButton.extended(
            label: Text(widget.prefs.getInt('isMinute') == 1500
                ? "Fokuslan"
                : "Mola Ver"),
            onPressed: () {
              timerBloc
                  .add(EventStarted(duration: widget.prefs.getInt('isMinute')));
              setState(() {
                print(widget.prefs.getInt('isMinute').toString());
                widget.prefs.getInt('isMinute') == 1500
                    ? widget.prefs.setInt('isMinute', min_5)
                    : widget.prefs.setInt('isMinute', min_25);
              });
            }),
      ];
    }
    if (currentState is StatePause) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => timerBloc.add(EventResumed()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc
              .add(EventReset(duration: widget.prefs.getInt('isMinute'))),
        ),
        FloatingActionButton.extended(
            label: Text(widget.prefs.getInt('isMinute') == 1500
                ? "Fokuslan"
                : "Mola Ver"),
            onPressed: () {
              timerBloc
                  .add(EventStarted(duration: widget.prefs.getInt('isMinute')));
              setState(() {
                print(widget.prefs.getInt('isMinute').toString());
                widget.prefs.getInt('isMinute') == 1500
                    ? widget.prefs.setInt('isMinute', min_5)
                    : widget.prefs.setInt('isMinute', min_25);
              });
            }),
      ];
    }
    if (currentState is StateComplete) {
      return [
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc
              .add(EventReset(duration: widget.prefs.getInt('isMinute'))),
        ),
        FloatingActionButton.extended(
            label: Text(widget.prefs.getInt('isMinute') == 1500
                ? "Fokuslan"
                : "Mola Ver"),
            onPressed: () {
              timerBloc
                  .add(EventStarted(duration: widget.prefs.getInt('isMinute')));
              setState(() {
                print(widget.prefs.getInt('isMinute').toString());
                widget.prefs.getInt('isMinute') == 1500
                    ? widget.prefs.setInt('isMinute', min_5)
                    : widget.prefs.setInt('isMinute', min_25);
              });
            }),
      ];
    }
    return [];
  }
}
