import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:project/model/project_model.dart';

class ProjectService {
  String imagename = DateTime.now().microsecondsSinceEpoch.toString();
  String url = '';
  Reference firebaseStorage = FirebaseStorage.instance.ref();
  String collectionRef = 'students';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late final CollectionReference<ProjectModel> studentRef =
      firestore.collection(collectionRef).withConverter<ProjectModel>(
            fromFirestore: (snapshot, options) =>
                ProjectModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<void> addimage(File image, BuildContext context) async {
    Reference imageFolder = firebaseStorage.child('images');
    Reference uploadedimage = imageFolder.child("$imagename.jpg");
    try {
      await uploadedimage.putFile(image);
      url = await uploadedimage.getDownloadURL();
    } catch (e) {
      throw Exception('failed to upload image $e');
    }
  }

  Future updateImage(
      String imageurl, File updateimage, BuildContext context) async {
    try {
      Reference editImageRef = FirebaseStorage.instance.refFromURL(imageurl);
      await editImageRef.putFile(updateimage);
      String newUrl = await editImageRef.getDownloadURL();

      return newUrl;
    } catch (e) {
      throw Exception('failed to update image$e');
    }
  }

  Future<void> deleteImage(String imageurl, BuildContext context) async {
    try {
      Reference delete = FirebaseStorage.instance.refFromURL(imageurl);
      await delete.delete();
    } catch (e) {
      throw Exception('failed to delete $e');
    }
  }

 Future<void> addData(ProjectModel model) async {
    try {
        await studentRef.add(model);
    } catch (e) {
        throw Exception('Failed to add data $e');
    }
}


  Stream<QuerySnapshot<ProjectModel>> getdata() {
    return studentRef.snapshots();
  }

  Future<void> deletedata(String id) async {
    try {
      await studentRef.doc(id).delete();
    } catch (e) {
      print('failed to deletedata $e');
    }
  }

  Future<void> updatedata(ProjectModel model, String id) async {
    try {
      await studentRef.doc(id).update(model.toJson());
    } catch (e) {
      print('Failed to update data: ${e.toString()}'); 
    }
  }
}
