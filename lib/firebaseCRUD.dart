import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/showdata.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CRUD extends StatefulWidget {
  const CRUD({super.key});

  @override
  State<CRUD> createState() => _CRUDState();
}

class _CRUDState extends State<CRUD> {

  final TextEditingController _textFieldController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    String currentTime = DateTime.now().microsecondsSinceEpoch.toString();
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Flutter-FireBase Connnection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextFormField(
              controller: _textFieldController,
              decoration: InputDecoration(
                labelText: 'Enter your Data',
                border: OutlineInputBorder(),
              )
              ),
              SizedBox(
                height: 30,
              ),
              OutlinedButton(
// -----------------ADD DATA LOGIC--------------------------
                onPressed: () {
                  print("hi");
                  // Get current timestamp
                  String currentTime = DateTime.now().millisecondsSinceEpoch.toString();

                  // Fetch existing skills data
                  databaseRef.child('skills').once().then((DatabaseEvent event) {
                    DataSnapshot snapshot = event.snapshot;
                    Map<dynamic, dynamic> existingSkills = snapshot.value ?? {} as dynamic; // If null, initialize as empty map

                    // Append the new skill
                    existingSkills[currentTime] = _textFieldController.text.toString();

                    // Update the skills node with the updated data
                    databaseRef.child('skills').set(existingSkills).then((_) {
                      Utils.toastMessage("Post Added");
                      // Clear the text field after successfully adding the data
                      _textFieldController.clear();
                    }).catchError((error) {
                      print("Error: $error");
                      Utils.toastMessage(error.toString());
                    });
                  }).catchError((error) {
                    print("Error: $error");
                    Utils.toastMessage(error.toString());
                  });
                },
// -----------------END OF ADD DATA LOGIC--------------------------

              child: Text("Enter the Data"),
              ),
              SizedBox(
                height: 15,
              ),
              FilledButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowData()));
              }, child: Text("Show Data")),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Utils {
  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
