import 'package:co2sensor/bloc/app/app_bloc.dart';
import 'package:co2sensor/bloc/notification/notification_bloc.dart';
import 'package:co2sensor/models/app_config.dart';
import 'package:co2sensor/repos/firebase_repository.dart';
import 'package:co2sensor/repos/storage_repository.dart';
import 'package:co2sensor/screens/home_screen.dart';
import 'package:co2sensor/screens/loading_screen.dart';
import 'package:co2sensor/screens/start_screen.dart';
import 'package:co2sensor/theming/theme.dart';
import 'package:co2sensor/utils/logger.dart';
import 'package:co2sensor/utils/simple_bloc_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(MyApp());
}

void setup() {
  GetIt.I.registerSingleton<StorageRepository>(
      SharedPreferencesStorageRepository());
  GetIt.I.get<StorageRepository>().initialize();

  GetIt.I.registerSingleton<AbstractFirebaseRepository>(FirebaseRepository());

  initLogger(prefix: 'CO2');

  assert(() {
    // Print all Bloc-Changes only in debug mode
    Bloc.observer = SimpleBlocObserver();

    // Log every Log call
    // Logger.root.level = Level.ALL;
    // Logger.root.onRecord.listen((event) {
    //   print('${event.level.name}: ${event.time}: ${event.message}');
    // });
    return true;
  }());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CO2 Sensor',
      theme: Co2Theme.lightTheme,
      home: AppProvider(child: HomeWrapper()),
    );
  }
}

class AppProvider extends StatelessWidget {
  final Widget child;
  const AppProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationProvider(
      child: BlocProvider<AppBloc>(
        create: (context) {
          return AppBloc(context.read<NotificationBloc>())
            ..add(InitializeEvent());
        },
        child: child,
      ),
    );
  }
}

class NotificationProvider extends StatelessWidget {
  final Widget child;

  const NotificationProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (context) {
        return NotificationBloc();
      },
      child: child,
    );
  }
}

class HomeWrapper extends StatefulWidget {
  HomeWrapper({Key? key}) : super(key: key);

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state.loading) {
          return LoadingScreen();
        } else {
          if (state.config == AppConfig.empty()) {
            return StartScreen();
          } else {
            return HomeScreen();
          }
        }
      },
    );
  }
}
