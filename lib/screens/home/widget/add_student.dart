import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newstudent/db/function/db_functons.dart';
import 'package:newstudent/db/model/data_model.dart';
import 'package:newstudent/screens/home/widget/list_student.dart';

class AddStudentWidget extends StatefulWidget {
  const AddStudentWidget({Key? key}) : super(key: key);

  @override
  State<AddStudentWidget> createState() => _AddStudentWidgetState();
}

class _AddStudentWidgetState extends State<AddStudentWidget> {
  final _nameController = TextEditingController();

  final _ageController = TextEditingController();

  final _departmentController = TextEditingController();

  final _locationController = TextEditingController();

  // final _guardianController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();

  File? _imageFile;

  // loading
  

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage('asset/image/filepicker.png')
                            as ImageProvider<Object>,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            TextFormField(
              controller: _nameController,
              maxLength: 10,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                    
                    ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _ageController,
              maxLength: 2,
              
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _departmentController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Email';
                }
                final emailRegex =
                    RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid Email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _locationController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Location';
                }
                return null;
              },
            ),
            ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    onAddStudentButtonClicked();
                  }
                },
                icon: const Icon(Icons.add),
                
                label: const Text('add student')),
           
           
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListStudentWidget(),
                      ));
                },
                icon: const Icon(Icons.list),
                label: const Text('list view',)),
          ],
          
        ),
      ),
      
    );
      
  }

  Future<void> onAddStudentButtonClicked() async {
    final _name = _nameController.text.trim();
    final _age = _ageController.text.trim();
    final _department = _departmentController.text.trim();
    final _location = _locationController.text.trim();
    // final _guardian = _guardianController.text.trim();

    if (_name.isEmpty ||
        _age.isEmpty ||
        _department.isEmpty ||
        _location.isEmpty) {
      return;
    }
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
          content: Text('please add your picture!'),
        ),
      );
    }

    final bytes = await _imageFile!.readAsBytes();
    final String base64Image = base64Encode(bytes);

    StudentModel _student = StudentModel(
      name: _name,
      age: _age,
      department: _department,
      location: _location,
      profilePhoto: base64Image,
    );
    addStudent(_student);
    _nameController.clear();
    _ageController.clear();
    _departmentController.clear();
    _locationController.clear();
    setState(() {
      _imageFile = null;
    });

    showDialog(context: context,
    
     builder: (BuildContext context){
       return AlertDialog(
        title:const Text('Succes'),
        content:const Text('Student added succesfully!'),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          },
           child:const Text('ok'),
           ),
        ],
       );
     },
     );
     
  }
}
