// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Leaders {
  String name;
  int points;
  Leaders({
    required this.name,
    required this.points,
  });

  Leaders copyWith({
    String? name,
    int? points,
  }) {
    return Leaders(
      name: name ?? this.name,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'points': points,
    };
  }

  factory Leaders.fromMap(Map<String, dynamic> map) {
    return Leaders(
      name: map['name'] as String,
      points: map['points'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Leaders.fromJson(String source) => Leaders.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Leaders(name: $name, points: $points)';

  @override
  bool operator ==(covariant Leaders other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.points == points;
  }

  @override
  int get hashCode => name.hashCode ^ points.hashCode;
}
