part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class EventStarted extends TimerEvent {
  final int duration;

  const EventStarted({@required this.duration});

  @override
  String toString() => "EventStarted { duration: $duration }";
}

class EventPaused extends TimerEvent {}

class EventResumed extends TimerEvent {}

class EventReset extends TimerEvent {
  final int duration;

  const EventReset({@required this.duration});
  @override
  String toString() => "EventReset { duration: $duration }";
}

class EventTicked extends TimerEvent {
  final int duration;

  const EventTicked({@required this.duration});

  @override
  List<Object> get props => [duration];

  @override
  String toString() => "EventTicked { duration: $duration }";
}
