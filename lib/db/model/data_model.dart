

import 'package:hive_flutter/adapters.dart';
part 'data_model.g.dart';

@HiveType(typeId: 1)
class StudentModel {
  @HiveField(0)
   int? id;

  @HiveField(1)
   final String name;


   @HiveField(2)
   final String age;
    
   @HiveField(3) 
   final String department;
   
   @HiveField(4)
   final String location;
   
   @HiveField(5)
   String? profilePhoto;

  //  @HiveField(6)
  //  final String guardian;

  StudentModel({required this.name, required this.age, required this.department, required this.location,required this.profilePhoto, this.id});

  

   
}