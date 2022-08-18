import 'package:stacked/stacked.dart';
import 'package:stacked_app_tutorial/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_app_tutorial/app/app.locator.dart';

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  String title = '';

  void doSomething() {
    _navigationService.navigateTo(Routes.homePage);
  }
}