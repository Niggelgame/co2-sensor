import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class SimpleBlocObserver extends BlocObserver {
  final simpleBlocObserverLogger = Logger('SimpleBlocObserver');

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase cubit, Change change) {
    simpleBlocObserverLogger.finest("${cubit.runtimeType} $change");
    super.onChange(cubit, change);
  }
}
