class PlayerModel {
  final int id;
  final String username;

  PlayerModel({this.id, this.username});

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] ?? -1,
      username: json['username'] ?? '',
    );
  }
}
