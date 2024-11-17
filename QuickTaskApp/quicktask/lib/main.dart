import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:quicktask/screens/login_screen.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'XrdUAkqPN9t38C0OhfNHyY4DqM9rcKjHuynx3lS4';
  const keyClientKey = '9GVlFqAhVNxeYVxOtqcWyy6k61hTsgzvoE3ty5Tq';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen()
    );
  }
}

