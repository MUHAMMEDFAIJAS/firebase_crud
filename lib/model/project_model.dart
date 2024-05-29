class ProjectModel {
  String? name;
  String? email;
  String? address;
  String? image;

  ProjectModel({
    this.name,
    this.email,
    this.address,
    this.image,
  });

  ProjectModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    address = json['address'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name':name,
      'email':email,
      'address':address,
      'image':image,
    };
  }
}
