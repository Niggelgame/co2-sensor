import 'package:co2sensor/bloc/app/app_bloc.dart';
import 'package:co2sensor/models/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello",
              style: Theme.of(context).textTheme.headline1,
            ),
            Center(
              child: TextField(
                autocorrect: false,
                decoration: InputDecoration(hintText: "URL to Data-Server"),
                controller: controller,
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  var bloc = context.read<AppBloc>();

                  bloc.add(SetConfigEvent(AppConfig(controller.text, null)));
                },
                child: Text("Save and connect"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
