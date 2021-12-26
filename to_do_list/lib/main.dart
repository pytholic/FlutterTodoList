import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/page/home_page.dart';
import 'package:to_do_list/provider/todos.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = "Pytholic's Todo App";

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => TodosProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            //primarySwatch: Colors.pink, // Todo "title text" color
            //primarySwatch: Colors.indigo.shade200,
            scaffoldBackgroundColor: Color(0xFFf6f5ee),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.deepPurple[300], //.blueAccent[100],
            ),
          ),
          home: HomePage(),
        ),
      );
}
