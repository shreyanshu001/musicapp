import 'package:music_app/domain/music_service.dart';

abstract class MusicServiceRepository {
  Future<List<MusicService>> getMusicServices();
  Stream<List<MusicService>> getMusicServicesStream();
}
