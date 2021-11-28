
import 'package:co2sensor/widgets/graph.dart';
import 'package:co2sensor/provider/app/app_provider.dart';
import 'package:co2sensor/provider/notification/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationStateProvider);
  
    return Scaffold(
      appBar: AppBar(
        title: Text('CO2'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(logoutProvider).logout();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 500,
                child: Graph(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
