part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;

  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class StateInitial extends TimerState {
  const StateInitial(int duration) : super(duration);

  @override
  String toString() => 'StateInitial { duration: $duration }';
}

class StatePause extends TimerState {
  const StatePause(int duration) : super(duration);

  @override
  String toString() => 'StatePause { duration: $duration }';
}

class StateRuning extends TimerState {
  const StateRuning(int duration) : super(duration);

  @override
  String toString() => 'StateRuning { duration: $duration }';
}

class StateComplete extends TimerState {
  const StateComplete() : super(0);
}
