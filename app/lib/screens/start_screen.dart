import 'package:co2sensor/models/app_config.dart';
import 'package:co2sensor/provider/app/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final startScreenTextEditingControllerProvider = Provider((_) => TextEditingController());

class StartScreen extends ConsumerWidget {
@override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(startScreenTextEditingControllerProvider);
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
                  ref.read(appProvider.notifier).setConfig(AppConfig(controller.text));
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
