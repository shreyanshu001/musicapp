import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_app/data/repos/music_service_repo.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/music_service.dart';
import '../models/music_service_model.dart';

class MusicServiceRepositoryImpl implements MusicServiceRepository {
  final FirebaseFirestore firestore;

  const MusicServiceRepositoryImpl({required this.firestore});

  @override
  Future<List<MusicService>> getMusicServices() async {
    try {
      final querySnapshot = await firestore
          .collection(AppConstants.musicServicesCollection)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              MusicServiceModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch music services: $e');
    }
  }

  @override
  Stream<List<MusicService>> getMusicServicesStream() {
    try {
      return firestore
          .collection(AppConstants.musicServicesCollection)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) =>
                  MusicServiceModel.fromJson(doc.data(), doc.id).toEntity())
              .toList());
    } catch (e) {
      throw Exception('Failed to get music services stream: $e');
    }
  }
}
