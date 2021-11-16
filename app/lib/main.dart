import 'package:co2sensor/models/app_config.dart';
import 'package:co2sensor/provider/app/app_provider.dart';
import 'package:co2sensor/screens/home_screen.dart';
import 'package:co2sensor/screens/loading_screen.dart';
import 'package:co2sensor/screens/start_screen.dart';
import 'package:co2sensor/theming/theme.dart';
import 'package:co2sensor/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // const options = FirebaseOptions(
  //     apiKey: 'AIzaSyDUUJwmb2VhClD06pRWvyCghLIcnUEBoeA',
  //     appId: '1:592855333182:android:41d220b10070b00fa9946f',
  //     messagingSenderId: '592855333182',
  //     projectId: 'co2-sensor-df995');
  // await Firebase.initializeApp(options: options);

  setup();

  runApp(ProviderScope(child: MyApp()));
}

void setup() {

  initLogger(prefix: 'CO2');

  assert(() {
    // Print all Bloc-Changes only in debug mode
    // Bloc.observer = SimpleBlocObserver();

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
      home: HomeWrapper(),
    );
  }
}

class HomeWrapper extends ConsumerWidget  {
  final homeWrapperLogger = Logger("HomeWrapper");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);

    ref.listen<String?>(connectionUrlProvider, (String? previous,String? next) { 
      homeWrapperLogger.info("New Connection URL: $next");
    });
    if(appState.loading) {
      return LoadingScreen();
    }
    if(appState.config == AppConfig.empty()) {
      return StartScreen();
    } else {
      return HomeScreen();
    }
  }
}
