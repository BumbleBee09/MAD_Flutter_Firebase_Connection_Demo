import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'firebaseCRUD.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  final databaseRef = FirebaseDatabase.instance.ref('Post').child('skills');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Display Data"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseRef,
              itemBuilder: (context, snapshot, animation, index) {
                String? skillKey = snapshot.key;
                String skillValue = snapshot.value.toString();
                return ListTile(
                  title: Text(skillValue),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          showUpdateDialog(context, databaseRef, skillKey!, skillValue);
                        },
                        value: 1,
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text("Update"),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          deleteSkill(databaseRef, skillKey!, skillValue);
                        },
                        value: 2,
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text("Delete"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

Future<void> deleteSkill(DatabaseReference databaseRef, String skillKey, String skillValue) async {
  await databaseRef.child(skillKey).remove();
  Utils.toastMessage("Skill ${skillValue} Deleted Successfully");
}

Future<void> showUpdateDialog(BuildContext context, DatabaseReference databaseRef, String skillKey, String currentSkillValue) async {
  TextEditingController skillController = TextEditingController(text: currentSkillValue);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Update Skill"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: skillController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String newSkillValue = skillController.text;
              if (newSkillValue.isNotEmpty) {
                // Update the skill in the database
                databaseRef.child(skillKey).set(newSkillValue);
                Utils.toastMessage("Skill ${currentSkillValue} Updated Successfully to ${newSkillValue}");
                Navigator.pop(context); // Close the dialog
              } else {
                Utils.toastMessage("Please enter a valid skill");
              }
            },
            child: Text("Update"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text("Cancel"),
          ),
        ],
      );
    },
  );
}

