import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/logger.dart';

/// Delegate handling interactions between the detail-image / thumbnail blocs
/// and the item bloc
class ImagesBlocDelegate extends BlocDelegate {
  final _log = getLogger();

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _log.d('Transition in ImagesBlocDelegate', transition);


  }
}