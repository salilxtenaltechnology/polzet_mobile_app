import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'connection_provider.dart';
import '../../presentation/screens/internet/no_internet.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  ConnectivityWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<ConnectivityProvider>().isConnected;

    return isConnected ? child : NoInternet();
  }
}
