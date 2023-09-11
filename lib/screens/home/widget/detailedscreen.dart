import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:newstudent/db/function/db_functons.dart';
import 'package:newstudent/db/model/data_model.dart';

class DetailedScreen extends StatefulWidget {
  final int index;
 const DetailedScreen(this.index);

  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _departmentController;
  late TextEditingController _locationController;
  late StudentModel _studentModel;
 

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _departmentController = TextEditingController();
    _locationController = TextEditingController();

    
    final studentList = studentListNotifier.value;
    _studentModel = studentList[widget.index];
    _nameController.text = _studentModel.name;
    _ageController.text = _studentModel.age.toString();
    _departmentController.text = _studentModel.department;
    _locationController.text = _studentModel.location;
   
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _departmentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

 

  Future<void> _updateStudent(StudentModel updatedStudent) async {
    if (_formKey.currentState!.validate()) {
      
      


      final studentDB = await Hive.openBox<StudentModel>('student_db');
      await studentDB.put(updatedStudent.id!, updatedStudent);
      await getAllStudent();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final base64image = _studentModel.profilePhoto;
    final imageBytes = base64.decode(base64image!);

    return ValueListenableBuilder<List<StudentModel>>(
        valueListenable: studentListNotifier,
        builder: (BuildContext context, List<StudentModel> studentlist,
            Widget? child) {
          final data = studentlist[widget.index];
          final base64Image = data.profilePhoto;
          final imageBytes = base64.decode(base64Image!);

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title:const Text('Detailed Student info'),
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Edit Student info'),
                                content: SingleChildScrollView(
                                  child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                        
                                        
                                        
                                          TextFormField(
                                            controller: _nameController,
                                            decoration: const InputDecoration(
                                              labelText: "Name",
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please Enter a name";
                                              }
                                             final emailRegex = RegExp(
                                                  r"^[A-Z]+[a-zA-Z'\s]*$");
                                              if (!emailRegex.hasMatch(value)) {
                                                return "Please enter a valid Name";
                                              }
                                              return null;
                                            },
                                          ),
                                         
                                         
                                         
                                          TextFormField(
                                            controller: _ageController,
                                            decoration: const InputDecoration(
                                              labelText: "Age",
                                            ),
                                            maxLength: 2,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please Enter a valid age";
                                              }
                                              return null;
                                            },
                                          ),
                                         
                                         
                                         
                                          TextFormField(
                                            controller: _departmentController,
                                            decoration: const InputDecoration(
                                              labelText: "Email",
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please Enter a Email";
                                              }
                                              final emailRegex = RegExp(
                                                  r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                                              if (!emailRegex.hasMatch(value)) {
                                                return "Please enter a valid Email";
                                              }
                                              return null;
                                            },
                                          ),
                                        
                                        
                                        
                                        
                                          TextFormField(
                                            controller: _locationController,
                                            decoration: const InputDecoration(
                                              labelText: "location",
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please Enter a department";
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      )),
                                ),
                                actions: [
                                  
                                  
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                
                                
                                  ElevatedButton(
                                    onPressed: () {
                                      final updatedStudent = StudentModel(
                                        id: _studentModel.id,
                                        name: _nameController.text,
                                        age: _ageController.text,
                                        department: _departmentController.text,
                                        profilePhoto:
                                            _studentModel.profilePhoto,
                                        location: _locationController.text,

                                        // guardian: _guardianController.text,
                                      );
                                      _updateStudent(updatedStudent);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ));
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            body: Center(
              child: Container(
                height: 600,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: Column(
                  children: [
                    Card(
                      child: Container(
                        width: 350,
                        height: 300,
                        child: Image(
                          image: MemoryImage(imageBytes),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        data.name,
                        style:const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: Text(
                        data.age,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.design_services),
                      title: Text(
                        data.department,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.design_services),
                      title: Text(
                        data.location,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}