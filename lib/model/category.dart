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

final festivalsCategory = Categoryy(
  categoryId: 2,
  name: "Festivals",
  icon: Icons.festival_outlined,
);

final eduCategory = Categoryy(
  categoryId: 3,
  name: "Education",
  icon: Icons.auto_stories,
);

final politicalCategory = Categoryy(
  categoryId: 4,
  name: "Political",
  icon: Icons.touch_app,
);

final sportsCategory = Categoryy(
  categoryId: 5,
  name: "Sports",
  icon: Icons.sports_score,
);

final meetupCategory = Categoryy(
  categoryId: 6,
  name: "Meetup",
  icon: Icons.people,
);

final bdayCategory = Categoryy(
  categoryId: 7,
  name: "Birthday",
  icon: Icons.cake,
);
final othersCategory = Categoryy(
  categoryId: 8,
  name: "Others",
  icon: Icons.search,
);

final categories = [
  allCategory,
  musicCategory,
  festivalsCategory,
  sportsCategory,
  eduCategory,
  politicalCategory,
  meetupCategory,
  bdayCategory,
  othersCategory
];
