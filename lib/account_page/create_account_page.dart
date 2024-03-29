import 'dart:io';

import 'package:SmartWedding/model/account.dart';
import 'package:SmartWedding/utils/authentication.dart';
import 'package:SmartWedding/utils/firestore/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  File? image;
  ImagePicker picker = ImagePicker();
  bool _isLoading = false;

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage(String uid) async {
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image!);

    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    print('image_path: $downloadUrl');
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('アカウント作成'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  getImageFromGallery();
                },
                child: CircleAvatar(
                  foregroundImage: image == null ? null : FileImage(image!),
                  radius: 40,
                  child: const Icon(Icons.add),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: '名前'),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'メールアドレス'),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: passController,
                      decoration: const InputDecoration(hintText: 'パスワード'),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                        if (nameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            passController.text.isNotEmpty &&
                            image != null) {
                          setState(() {
                            _isLoading = true;
                          });

                          var result = await Authentication.signUp(
                              email: emailController.text,
                              pass: passController.text);
                          if (result is UserCredential) {
                            String imagePath =
                            await uploadImage(result.user!.uid);

                            // Create an empty subcollection for the user's attendees
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(result.user!.uid)
                                .collection('groomAttendees')
                                .doc()
                                .set({});

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(result.user!.uid)
                                .collection('brideAttendees')
                                .doc()
                                .set({});

                            // Create an empty subcollection for the user's tasks
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(result.user!.uid)
                                .collection('TaskList')
                                .doc()
                                .set({});

                            // Save the user information
                            Account newAccount = Account(
                              id: result.user!.uid,
                              name: nameController.text,
                              imagePath: imagePath,
                            );
                            var _result =
                            await UserFirestore.setUser(newAccount);
                            if (_result == true) {
                              Navigator.pop(context);
                            }
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          print('未入力な項目がある');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text('未入力な項目があります',
                                    style: TextStyle(fontSize: 20)),
                                content: Text('全て必須項目です',
                                    style: TextStyle(fontSize: 8)),
                              );
                            },
                          );
                        }
                      },
                      child: const Text('登録'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}