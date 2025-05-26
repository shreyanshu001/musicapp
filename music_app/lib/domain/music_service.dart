class MusicService {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final bool isActive;

  const MusicService({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.isActive,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MusicService &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.iconName == iconName &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        iconName.hashCode ^
        isActive.hashCode;
  }

  @override
  String toString() {
    return 'MusicService{id: $id, title: $title, description: $description, iconName: $iconName, isActive: $isActive}';
  }
}
