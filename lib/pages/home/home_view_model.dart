import 'package:stacked/stacked.dart';
import 'package:stacked_app_tutorial/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_app_tutorial/app/app.locator.dart';

class HomePageViewModel extends BaseViewModel {
  String _title = 'Home View';
  String get title => '$_title Counter: $counter';
  final _navigationService = locator<NavigationService>();

  int _counter = 0;
  int get counter => _counter;

  void updateCounter() {
    _counter++;
    notifyListeners();
  }

  void goBack() {
    _navigationService.navigateTo(Routes.startUpPage);
  }

}