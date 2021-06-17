import 'package:co2sensor/bloc/app/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CO2'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AppBloc>().add(LogoutEvent());
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.red,
          height: 500,
        ),
      ),
    );
  }
}
