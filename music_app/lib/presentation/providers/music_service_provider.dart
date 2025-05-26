import 'package:flutter/foundation.dart';
import 'package:music_app/data/repos/music_service_repo.dart';
import '../../domain/music_service.dart';

enum MusicServicesState { initial, loading, loaded, error }

class MusicServicesProvider extends ChangeNotifier {
  final MusicServiceRepository repository;

  MusicServicesProvider({required this.repository});

  // State
  MusicServicesState _state = MusicServicesState.initial;
  List<MusicService> _services = [];
  String _errorMessage = '';

  // Getters
  MusicServicesState get state => _state;
  List<MusicService> get services => _services;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == MusicServicesState.loading;
  bool get hasError => _state == MusicServicesState.error;
  bool get hasData =>
      _state == MusicServicesState.loaded && _services.isNotEmpty;

  // Methods
  Future<void> loadMusicServices() async {
    _setState(MusicServicesState.loading);

    try {
      final services = await repository.getMusicServices();
      _services = services;
      _setState(MusicServicesState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(MusicServicesState.error);
    }
  }

  void retry() {
    loadMusicServices();
  }

  void _setState(MusicServicesState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
