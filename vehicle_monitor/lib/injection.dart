import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_monitor/core/auth.dart';
import 'package:vehicle_monitor/core/repository.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Article
  // Bloc
  // serviceLocator.registerFactory(
  //   () => ArticleBloc(
  //       createArticle: serviceLocator(),
  //       deleteArticle: serviceLocator(),
  //       getAllArticles: serviceLocator(),
  //       getArticle: serviceLocator(),
  //       updateArticle: serviceLocator(),
  //       filterArticles: serviceLocator()),
  // );

  serviceLocator.registerLazySingleton(
    () => Repository(auth: serviceLocator(), prefs: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => Auth(),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
}
