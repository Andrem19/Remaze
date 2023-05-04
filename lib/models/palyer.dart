import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Player {
  String uid;
  String userName;
  bool? is_Player_A_in_current_game;
  String? currentGame;
  int? points;

  Player({
    required this.uid,
    required this.userName,
    this.is_Player_A_in_current_game,
    this.currentGame,
    this.points,
  });

  Player copyWith({
    String? uid,
    String? userName,
    bool? is_Player_A_in_current_game,
    String? currentGame,
    int? points,
  }) {
    return Player(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      is_Player_A_in_current_game: is_Player_A_in_current_game ?? this.is_Player_A_in_current_game,
      currentGame: currentGame ?? this.currentGame,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'is_Player_A_in_current_game': is_Player_A_in_current_game,
      'currentGame': currentGame,
      'points': points,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      is_Player_A_in_current_game: map['is_Player_A_in_current_game'] != null ? map['is_Player_A_in_current_game'] as bool : null,
      currentGame: map['currentGame'] != null ? map['currentGame'] as String : null,
      points: map['points'] != null ? map['points'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Player(uid: $uid, userName: $userName, is_Player_A_in_current_game: $is_Player_A_in_current_game, currentGame: $currentGame, points: $points)';
  }

  @override
  bool operator ==(covariant Player other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.userName == userName &&
      other.is_Player_A_in_current_game == is_Player_A_in_current_game &&
      other.currentGame == currentGame &&
      other.points == points;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      userName.hashCode ^
      is_Player_A_in_current_game.hashCode ^
      currentGame.hashCode ^
      points.hashCode;
  }
}
