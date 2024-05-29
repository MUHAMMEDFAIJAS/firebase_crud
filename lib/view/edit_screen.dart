import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:project/controller/image_provider.dart';
import 'package:project/controller/provider.dart';
import 'package:project/model/project_model.dart';
import 'package:project/services/project_service.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  final String id;
  final ProjectModel prmodel;
  const EditPage({super.key, required this.id, required this.prmodel});

  @override
  // ignore: library_private_types_in_public_api
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;
  bool isNewImagePicked = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.prmodel.name);
    emailCtrl = TextEditingController(text: widget.prmodel.email);
    addressCtrl = TextEditingController(text: widget.prmodel.address);
    Provider.of<ImageProviderr>(context, listen: false).editpickedImage =
        File(widget.prmodel.image.toString());
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageProviderr>(context, listen: false);
    log("editScreen");

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Gap(20),
            Consumer<ImageProviderr>(builder: (context, pro, _) {
              return CircleAvatar(
                radius: 40,
                backgroundImage: isNewImagePicked
                    ? FileImage(pro.editpickedImage!)
                    : widget.prmodel.image != null
                        ? NetworkImage(widget.prmodel.image.toString())
                            as ImageProvider
                        : null,
              );
            }),
            TextButton(
              onPressed: () async {
                await provider.editpickimg();
                setState(() {
                  isNewImagePicked = true;
                });
              },
              child: const Text("Pick Image"),
            ),
            const Gap(20),
            TextFormField(
              controller: nameCtrl,
              decoration: InputDecoration(
                label: const Text("Name"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const Gap(15),
            TextFormField(
              controller: emailCtrl,
              decoration: InputDecoration(
                label: const Text("Email"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const Gap(15),
            TextFormField(
              controller: addressCtrl,
              decoration: InputDecoration(
                label: const Text("Address"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const Gap(15),
            ElevatedButton(
              onPressed: () async {
                await editStudentData(context);
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editStudentData(BuildContext context) async {
    ProjectService services = ProjectService();
    final provider = Provider.of<Projectprovider>(context, listen: false);
    final imageProvider = Provider.of<ImageProviderr>(context, listen: false);

    String imageUrl = widget.prmodel.image.toString();
    if (isNewImagePicked) {
      imageUrl = await services.updateImage(
          imageUrl, File(imageProvider.editpickedImage!.path), context);
    }

    final newData = ProjectModel(
      name: nameCtrl.text,
      email: emailCtrl.text,
      address: addressCtrl.text,
      image: imageUrl,
    );

    await provider.updatedatastudent(context, newData, widget.id);
    Navigator.pop(context);
  }
}
