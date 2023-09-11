import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newstudent/db/model/data_model.dart';
import 'package:newstudent/screens/home/screen_home.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(StudentModelAdapter().typeId)) {
    Hive.registerAdapter(StudentModelAdapter());
  }
  runApp(const runapp());
}

class runapp extends StatelessWidget {
  const runapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 123, 73, 211)),
      home:const ScreenHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
