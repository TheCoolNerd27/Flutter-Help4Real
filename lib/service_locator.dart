import 'package:get_it/get_it.dart';
import 'package:help4real/auth_service.dart';
GetIt locator = GetIt.instance;

void setupLocator() {

    locator.registerLazySingleton(() => AuthenticationService());

}