// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/controller/image_provider.dart';
import 'package:project/controller/provider.dart';
import 'package:project/model/project_model.dart';
import 'package:project/services/project_service.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  AddScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Consumer<ImageProviderr>(builder: (context, pro, _) {
                      return FutureBuilder(
                        future: Future.value(pro.pickedImage),
                        builder: (context, snapshot) {
                          return CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 125, 124, 122),
                            radius: 40,
                            backgroundImage: snapshot.data != null
                                ? FileImage(snapshot.data!)
                                : null,
                          );
                        },
                      );
                    }),
                    TextButton(
                      onPressed: () {
                        Provider.of<ImageProviderr>(context, listen: false)
                            .pickImg();
                      },
                      child: const Text("Pick Image"),
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: 'name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: 'email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                          hintText: 'address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          add(context);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future<void> add(BuildContext context) async {
    try {
      ProjectService service = ProjectService();
      final imageprovider = Provider.of<ImageProviderr>(context, listen: false);

      if (imageprovider.pickedImage == null) {
        throw Exception('No image selected');
      }

      await service.addimage(File(imageprovider.pickedImage!.path));

      final pro = Provider.of<Projectprovider>(context, listen: false);

      final prmodel = ProjectModel(
        name: nameController.text,
        email: emailController.text,
        address: addressController.text,
        image: service.url,
      );

      await pro.adddataStudent(context, prmodel);

      imageprovider.clearpickedimage();
      Navigator.pop(context);
    } catch (e) {
      print('Failed to add data: $e');
      // Optionally show a dialog or a Snackbar with the error message
    }
  }
}
