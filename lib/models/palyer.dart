import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Player {
  String uid;
  String userName;
  String deviceId;
  bool? is_Player_A_in_current_game;
  String? currentGame;
  String? migrationToken;

  int? points;

  Player({
    required this.uid,
    required this.userName,
    required this.deviceId,
    this.is_Player_A_in_current_game,
    this.currentGame,
    this.migrationToken,
    this.points,
  });

  Player copyWith({
    String? uid,
    String? userName,
    String? deviceId,
    bool? is_Player_A_in_current_game,
    String? currentGame,
    String? migrationToken,
    int? points,
  }) {
    return Player(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      deviceId: deviceId ?? this.deviceId,
      is_Player_A_in_current_game: is_Player_A_in_current_game ?? this.is_Player_A_in_current_game,
      currentGame: currentGame ?? this.currentGame,
      migrationToken: migrationToken ?? this.migrationToken,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'deviceId': deviceId,
      'is_Player_A_in_current_game': is_Player_A_in_current_game,
      'currentGame': currentGame,
      'migrationToken': migrationToken,
      'points': points,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      deviceId: map['deviceId'] as String,
      is_Player_A_in_current_game: map['is_Player_A_in_current_game'] != null ? map['is_Player_A_in_current_game'] as bool : null,
      currentGame: map['currentGame'] != null ? map['currentGame'] as String : null,
      migrationToken: map['migrationToken'] != null ? map['migrationToken'] as String : null,
      points: map['points'] != null ? map['points'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Player(uid: $uid, userName: $userName, deviceId: $deviceId, is_Player_A_in_current_game: $is_Player_A_in_current_game, currentGame: $currentGame, migrationToken: $migrationToken, points: $points)';
  }

  @override
  bool operator ==(covariant Player other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.userName == userName &&
      other.deviceId == deviceId &&
      other.is_Player_A_in_current_game == is_Player_A_in_current_game &&
      other.currentGame == currentGame &&
      other.migrationToken == migrationToken &&
      other.points == points;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      userName.hashCode ^
      deviceId.hashCode ^
      is_Player_A_in_current_game.hashCode ^
      currentGame.hashCode ^
      migrationToken.hashCode ^
      points.hashCode;
  }
}
