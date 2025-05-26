import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/data/repos/music_service_repo.dart';
import 'package:music_app/data/repos/music_service_repo_impl.dart';
import 'package:music_app/presentation/providers/music_service_provider.dart';

final sl = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Repository
  sl.registerLazySingleton<MusicServiceRepository>(
    () => MusicServiceRepositoryImpl(firestore: sl()),
  );

  // Provider
  sl.registerFactory(() => MusicServicesProvider(repository: sl()));
}
