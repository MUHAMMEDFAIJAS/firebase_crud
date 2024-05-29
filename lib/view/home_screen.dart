import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/controller/provider.dart';
import 'package:project/model/project_model.dart';
import 'package:project/services/project_service.dart';
import 'package:project/view/add_screen.dart';
import 'package:project/view/edit_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<Projectprovider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOMESCREEN'),
      ),
      body: StreamBuilder(
        stream: pro.getdatastudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            List<QueryDocumentSnapshot<ProjectModel>> studentDoc =
                snapshot.data?.docs ?? [];
            if (studentDoc.isEmpty) {
              return const Center(
                child: Text('no data available'),
              );
            }
            return ListView.builder(
              itemCount: studentDoc.length,
              itemBuilder: (context, index) {
                final id = studentDoc[index].id;
                final data = studentDoc[index].data();

                return ListTile(
                  leading: CircleAvatar(
                    child: Image.network(data.image.toString()),
                  ),
                  title: Text(data.name ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            pro.deletedatastudent(context, id);
                            ProjectService()
                                .deleteImage(data.image.toString(), context);
                          },
                          icon: const Icon(Icons.delete)),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditPage(
                                  id: id,
                                  prmodel: ProjectModel(
                                      name: data.name,
                                      email: data.email,
                                      address: data.address,
                                      image: data.image)),
                            ));
                          },
                          icon: const Icon(Icons.edit))
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
