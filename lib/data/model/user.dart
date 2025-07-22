enum InjuryStatus { none, mild, severe }

class User {
  String username;
  int age;
  double height;
  double weight;
  String gender;
  InjuryStatus injuryStatus;

  User({
    required this.username,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.injuryStatus,
  });
}
