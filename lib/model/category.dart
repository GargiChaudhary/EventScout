import 'package:flutter/material.dart';

class Categoryy {
  final int categoryId;
  final String name;
  final IconData icon;

  Categoryy({required this.categoryId, required this.name, required this.icon});
}

final allCategory = Categoryy(
  categoryId: 0,
  name: "All",
  icon: Icons.search,
);

final musicCategory = Categoryy(
  categoryId: 1,
  name: "Music",
  icon: Icons.music_note,
);

final meetUpCategory = Categoryy(
  categoryId: 2,
  name: "Meetup",
  icon: Icons.location_on,
);

final golfCategory = Categoryy(
  categoryId: 3,
  name: "Golf",
  icon: Icons.golf_course,
);

final birthdayCategory = Categoryy(
  categoryId: 4,
  name: "Birthday",
  icon: Icons.cake,
);

final categories = [
  allCategory,
  musicCategory,
  meetUpCategory,
  golfCategory,
  birthdayCategory,
];
