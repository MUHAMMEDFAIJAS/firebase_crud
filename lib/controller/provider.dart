import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:project/model/project_model.dart';
import 'package:project/services/project_service.dart';

class Projectprovider extends ChangeNotifier {
  ProjectService service = ProjectService();

  Future<void> adddataStudent(BuildContext context, ProjectModel model) async {
    try {
      await service.addData(model);
      notifyListeners();
    } catch (e) {
      throw Exception('failed to add student$e');
    }
  }

  Stream<QuerySnapshot<ProjectModel>> getdatastudents() {
    return service.getdata();
  }

  Future<void> deletedatastudent(BuildContext context, String id) async {
    try {
      await service.deletedata(id);
      notifyListeners();
    } catch (e) {
      throw Exception('faled to delete$e');
    }
  }

  Future<void> updatedatastudent(
      BuildContext context, ProjectModel model, String id) async {
    try {
      await service.updatedata(model, id);
      notifyListeners();
    } catch (e) {
      throw Exception('failed to update');
    }
  }
}
