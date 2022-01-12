import 'package:dumperplay/advertisements.dart';
import 'package:dumperplay/login.dart';
import 'package:dumperplay/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Myprovider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: login(context),
      theme: ThemeData(backgroundColor: Colors.grey.shade900),
    );
  }

  Widget login(BuildContext context) {
    var prov = Provider.of<Myprovider>(context);
    switch (prov.caseMyprovider) {
      case statmyprovide.auth:
        return MyHomePage();
      case statmyprovide.unauth:
        return Login();
      case statmyprovide.try_auth:
        return Login();
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static int index = 0;
  late advertisements a;

  @override
  void initState() {
    a = advertisements(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.grey.shade900,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.grey.shade900),
        excludeHeaderSemantics: true,
        toolbarHeight: 0.0,
        backgroundColor: Colors.grey.shade900,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey.shade900,
      body: IndexedStack(
        index: index,
        children: [a.create()],
      ),
    );
  }
}
