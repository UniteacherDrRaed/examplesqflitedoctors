class Doctor {
  int? id;
  final String name;
  final String address;

  Doctor({this.id, required this.name,
    required this.address});

  Map<String,Object?> toMap(){
    return {
      'name':name,
      'address':address
    };
  }
}
