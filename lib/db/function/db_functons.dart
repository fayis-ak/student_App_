import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newstudent/db/model/data_model.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);



Future<void> addStudent(StudentModel value)async{
  
  final studentDB = await Hive.openBox<StudentModel>('student_db');
  final _id =await studentDB.add(value);
  value.id = _id;

  studentListNotifier.value.add(value); 
  studentListNotifier.notifyListeners();
}

Future <void> getAllStudent()async{
  final studentDB = await Hive.openBox<StudentModel>('student_db');
  studentListNotifier.value.clear();

  studentListNotifier.value.addAll(studentDB.values);
  studentListNotifier.notifyListeners();

}


Future<void> deleteStudent(int id)async{
     final studentDB = await Hive.openBox<StudentModel>('student_db');
     await studentDB.delete(id);
     await getAllStudent();
}


Future<void>  notifyListeners()async{
  studentListNotifier.notifyListeners();
}