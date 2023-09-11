import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newstudent/db/function/db_functons.dart';
import 'package:newstudent/db/model/data_model.dart';
import 'package:newstudent/screens/home/widget/detailedscreen.dart';

class ListStudentWidget extends StatefulWidget {
  const ListStudentWidget({Key? key}) : super(key: key);

  @override
  State<ListStudentWidget> createState() => _ListStudentWidgetState();
}

class _ListStudentWidgetState extends State<ListStudentWidget> {

   final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(' Student Record'),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(onPressed: () {
            _perFormSearch();
          }, icon: const Icon(Icons.search)
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(padding:const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration:const InputDecoration(
              labelText: "Search",
              border: OutlineInputBorder(),
            ),
          ),
          ),
       
      
      
      
       Expanded(
         child: ValueListenableBuilder(
          valueListenable: studentListNotifier,
          builder:
              (BuildContext ctx, List<StudentModel> studentList, Widget? child) {
            if(studentList.isEmpty){
              return Center(
                child: Text('No Students available'),
              );
            }
            
            
            return ListView.separated(
              itemBuilder: (ctx, index) {
                final data = studentList[index];
                final base64Image = data.profilePhoto;
                final imageBytes = base64.decode(base64Image!);
       
                return ListTile(
                  //
                  leading: CircleAvatar(
                    backgroundImage: MemoryImage(imageBytes),
                    radius: 30,
                  ),
       
                  title: Text(data.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailedScreen(index)),
                    );
                  },
                  
       
                  trailing: IconButton(
                      onPressed: () {
                        if (data.id != null) {
                          deleteStudent(data.id!);
                        } else {
                          print('Student is is null unable to delete');
                        }
                      },
                      icon:const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemCount: studentList.length,
            );
          },
             ),
       ),
        ],
       ),
    );
  }

  void _perFormSearch(){
      final query = _searchController.text.trim().toLowerCase();

    final filteredList = studentListNotifier.value.where((student) {
      return student.name.toLowerCase().contains(query);
    }).toList();

    setState(() {
      studentListNotifier.value = filteredList;
     
    });
   
  }
}
