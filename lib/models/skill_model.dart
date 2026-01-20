class Skill {
  final String name;
  final int level; // 0-100
  final String icon;

  const Skill({
    required this.name,
    required this.level,
    required this.icon,
  });

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      name: map['name'] as String,
      level: map['level'] as int,
      icon: map['icon'] as String,
    );
  }
}

