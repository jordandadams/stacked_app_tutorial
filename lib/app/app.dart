import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_app_tutorial/pages/home/home_page.dart';
import 'package:stacked_app_tutorial/pages/startup/startup_page.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpPage, initial: true),
    CustomRoute(page: HomePage),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
  ],
)
class App {
  // Serves no purpose yet
}
