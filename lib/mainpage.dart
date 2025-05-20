import 'package:flutter/material.dart';
import 'package:untitled33/model/doctor.dart';
import 'package:untitled33/sqflitefordoctors/sqflitedb.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Doctor> listDoctors = [];
  bool loadingDoctors = true;
  fetchListDoctors() async {
    List<Doctor> allDoctors = await SqfliteDatabase.getAllDoctors();
    setState(() {
      listDoctors = allDoctors;
      loadingDoctors = false;
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  addNewDoctor() async {
    await SqfliteDatabase.addDoctor(
      Doctor(name: nameController.text, address: addressController.text),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchListDoctors();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Enter doctor info"),
                    content: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: "Name"),
                          controller: nameController,
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Address"),
                          controller: addressController,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          addNewDoctor();
                          nameController.clear();
                          addressController.clear();
                          fetchListDoctors();
                          Navigator.of(context).pop();
                        },
                        child: Text("add"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body:
          loadingDoctors
              ? Center(child: LinearProgressIndicator())
              : ListView.builder(
                itemCount: listDoctors.length,
                itemBuilder: (context, index) {
                  Doctor currentDoctor = listDoctors[index];
                  return Card(
                    child: ListTile(
                      leading: Text("${currentDoctor.id}"),
                      title: Text(currentDoctor.name),
                      subtitle: Text(currentDoctor.address),
                    ),
                  );
                },
              ),
    );
  }
}
