import 'package:flutter/material.dart';
import 'package:newstudent/db/function/db_functons.dart';
import 'package:newstudent/screens/home/widget/add_student.dart';


class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getAllStudent();
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:const Text('New Student Add'),
        backgroundColor: Colors.green,
      ),
      body:const SafeArea(
        child: Column(
          children: [
            AddStudentWidget(),
           
          ],
        ),
      ),
    );
  }
}
