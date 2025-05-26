import '../../domain/music_service.dart';

class MusicServiceModel extends MusicService {
  const MusicServiceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconName,
    required super.isActive,
  });

  factory MusicServiceModel.fromJson(Map<String, dynamic> json, String id) {
    return MusicServiceModel(
      id: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'music_note',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'iconName': iconName,
      'isActive': isActive,
    };
  }

  factory MusicServiceModel.fromEntity(MusicService entity) {
    return MusicServiceModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      iconName: entity.iconName,
      isActive: entity.isActive,
    );
  }

  MusicService toEntity() {
    return MusicService(
      id: id,
      title: title,
      description: description,
      iconName: iconName,
      isActive: isActive,
    );
  }
}
