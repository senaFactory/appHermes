class Student {
  final String dateBirth;
  final String bloodType;
  final String address;

  Student({
    required this.dateBirth,
    required this.bloodType,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {'dateBirth': dateBirth, 'bloodType': bloodType, 'address': address};
  }
}
