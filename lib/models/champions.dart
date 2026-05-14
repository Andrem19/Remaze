// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Champions {
  String name;
  int seconds;
  Champions({
    required this.name,
    required this.seconds,
  });

  Champions copyWith({
    String? name,
    int? seconds,
  }) {
    return Champions(
      name: name ?? this.name,
      seconds: seconds ?? this.seconds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'seconds': seconds,
    };
  }

  factory Champions.fromMap(Map<String, dynamic> map) {
    return Champions(
      name: map['name'] as String,
      seconds: map['seconds'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Champions.fromJson(String source) => Champions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Champions(name: $name, seconds: $seconds)';

  @override
  bool operator ==(covariant Champions other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.seconds == seconds;
  }

  @override
  int get hashCode => name.hashCode ^ seconds.hashCode;
}
