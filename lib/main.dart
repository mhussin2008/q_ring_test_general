import 'package:flutter/material.dart';
import 'Screens/StartUpScreen.dart';

void main()  async {
  FlutterError.onError = (FlutterErrorDetails details) {
    print(details);
    // Log or handle the error details
  };
  //
  WidgetsFlutterBinding.ensureInitialized();
print('started');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('myapp drawing');
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const startUpScreenUpdated(),
    );
  }
}

