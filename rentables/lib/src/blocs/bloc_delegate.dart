import 'package:bloc/bloc.dart';
import '../../rentables.dart';

/// Delegate for rentable blocs -> currently only used for logging
class RentableBlocDelegate extends BlocDelegate {
  final _log = getLogger();

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    _log.d(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _log.d(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    _log.e(error);
  }
}