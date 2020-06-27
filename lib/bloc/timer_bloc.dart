import 'dart:async';
import 'package:focus/utils/ticker.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Ticker _ticker;
  final int duration;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Ticker ticker, @required this.duration}) {
    if (ticker != null) _ticker = ticker;
  }

  @override
  TimerState get initialState => StateInitial(duration);

  @override
  void onTransition(Transition<TimerEvent, TimerState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is EventStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is EventPaused) {
      yield* _mapTimerPausedToState(event);
    } else if (event is EventResumed) {
      yield* _mapTimerResumedToState(event);
    } else if (event is EventReset) {
      yield* _mapTimerResetToState(event);
    } else if (event is EventTicked) {
      yield* _mapTimerTickedToState(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> _mapTimerStartedToState(EventStarted start) async* {
    yield StateRuning(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(EventTicked(duration: duration)));
  }

  Stream<TimerState> _mapTimerPausedToState(EventPaused pause) async* {
    if (state is StateRuning) {
      _tickerSubscription?.pause();
      yield StatePause(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResumedToState(EventResumed resume) async* {
    if (state is StatePause) {
      _tickerSubscription?.resume();
      yield StateRuning(state.duration);
    }
  }

  Stream<TimerState> _mapTimerResetToState(EventReset reset) async* {
    _tickerSubscription?.cancel();
    yield StateInitial(duration);
  }

  Stream<TimerState> _mapTimerTickedToState(EventTicked tick) async* {
    yield tick.duration > 0 ? StateRuning(tick.duration) : StateComplete();
  }
}
