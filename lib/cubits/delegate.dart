import '../utils/pb_log.dart';
import 'package:bloc/bloc.dart';

class PBObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    PBLog.info('BLOC onEvent $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    PBLog.debug('BLOC transition $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit bloc, Object error, StackTrace stackTrace) {
    PBLog.error('BLOC error $error');

    super.onError(bloc, error, stackTrace);
  }
}
