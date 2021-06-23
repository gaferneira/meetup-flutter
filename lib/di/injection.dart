import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_meetup/data/repositories/categories_respository.dart';
import 'package:flutter_meetup/data/repositories/categories_respository_impl.dart';
import 'package:flutter_meetup/data/repositories/events_repository.dart';
import 'package:flutter_meetup/data/repositories/events_repository_impl.dart';
import 'package:flutter_meetup/data/repositories/locations_repository.dart';
import 'package:flutter_meetup/data/repositories/locations_repository_impl.dart';
import 'package:flutter_meetup/data/repositories/sign_in_repository.dart';
import 'package:flutter_meetup/data/repositories/sign_in_repository_impl.dart';
import 'package:flutter_meetup/viewmodels/add_event_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/auth_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/events_details_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/events_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/explore_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/home/home_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureInjection() async {
  createDataSources();
  createRepositories();
  createViewModels();
}

void createDataSources() {
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseStorage.instance);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());
  getIt.registerLazySingletonAsync(() => SharedPreferences.getInstance());
}

void createRepositories() {
  getIt.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(firebaseFirestore: getIt()),
  );

  getIt.registerLazySingleton<EventsRepository>(
    () => EventsRepositoryImpl(
        firebaseFirestore: getIt(),
        firebaseStorage: getIt(),
        auth: getIt())
  );

  getIt.registerLazySingleton<LocationsRepository>(
    () => LocationsRepositoryImpl(firebaseFirestore: getIt()),
  );

  getIt.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(auth: getIt(), googleSignIn: getIt()),
  );
}

void createViewModels() {

  getIt.registerFactory(() => AddEventViewModel(
    categoriesRepository: getIt(),
    eventsRepository: getIt(),
    locationsRepository: getIt()
  ));

  getIt.registerFactory(() => AuthViewModel(
      repository: getIt(),
  ));

  getIt.registerFactory(() => EventsViewModel(
    repository: getIt(),
  ));

  getIt.registerFactory(() => ExploreViewModel(
    repository: getIt(),
  ));

  getIt.registerFactory(() => HomeViewModel(
    repository: getIt()
  ));

  getIt.registerFactory(() => EventsDetailsViewModel(
      repository: getIt()
  ));

}
