# Flutter/App Setup Documentation

# Stacked State Management:

## Architecture and Provider with Stacked:

*All information regarding Stacked can be found **[HERE](https://www.filledstacks.com/post/flutter-and-provider-architecture-using-stacked/)***

**NOTE**: This version better works on version `2.10.1` . You can find how to change versions easily [**HERE**](https://www.notion.so/Flutter-Version-Management-FVM-8a3f6180ef854b53a18acf9fcfd7e838).

*What is Stacked?*

- Stacked is an implementation of MVVM (Model View View Model) without the two way binding.

*How does Stacked Work?*

- Stacked consists of three parts only:
    - **Views** ⇒ UI that is shown to the user
    - **View Models** ⇒ Second layer down, where you control all of your logic and state for that specific view. Consists of no functionality, but includes services that implement certain functionalities.
    - **Services** ⇒ Simply just a `class` and wraps one set of functionality. One of the reasons we use services, is to wrap third-party dependencies so that your code is not dependent on a third-parties implementation details. The other equally common use-case is to wrap the functionality of a certain feature into a service.

*Rules **NOT** to Break with Stacked:*

- Views should NEVER MAKE USE of a service directly.
- Views should contain zero to (preferred) no logic. If the logic is from UI only items then we do the least amount of required logic and pass the rest to the ViewModel.
- Views should ONLY render the state in its ViewModel.
- One View has One ViewModel
- ViewModels for Widgets that represent page views are bound to a single View only.
- ViewModels may be re-used if the UI requires the exact same functionality
- ViewModels should not know about other ViewModels**

*What’s required for a Mobile Applications’ Architecture?*

- **State Management:** This is how you manage keeping the state of the application in sync with what’s being shown on the UI. We’ll be using Stacked for this part.
- **Navigation:** For this we’ll be using Flutters built in named routing functionality along with Get and auto_route to remove all the boilerplate code.
- **Inversion of Control:** This is a fancy term for using Dependency Injection or Service Location. For this we’ll use get_it and injectable to generate all the service code.
- **Data Models:** Here we will be using Freezed and Json_serializable to generate all of our models required in the app

## Flutter Project Setup:

*In this example I will be using an app called **stacked_app_tutorial***

Setup:

```dart
flutter create stacked_app_tutorial
```

Adding Stacked:

First thing I want to do is add stacked into the project and setup a basic View→ViewModel binding for me to see. Next, open the `pubspec.yaml` file and add the stacked package.

```dart
stacked ^2.3.15
//search for stacked package on Google to get the most up to date version
```

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/18afbf1c-b324-4c4d-9ecc-fe55f280c936/Untitled.png)

Under the lib folder create a new folder called `pages`. Inside that folder we will create two new files, `home_page.dart` and `home_view_model.dart`. Make sure these two files stay within the same folder.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/eed01003-a9ac-4ff6-8ff5-7fa5d945228e/Untitled.png)

The home view will have the basic code for associating a view with a ViewModel.

```dart
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePageModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Text(model.title),
        ),
      ),
      viewModelBuilder: () => HomePageModel(),
    );
  }
}
```

The `builder` provides the UI that will be “built from” the ViewModel. As you see we’re using the `.reactive` named constructor. This indicates that the builder will be called to rebuild the UI every time `notifyListeners` is called in the ViewModel. There is also a constructor `.nonReactive` which will only build the UI once and it won’t rebuild when `notifyListeners` is called in the ViewModel. The ViewModel look as follows below:

```dart
import 'package:stacked/stacked.dart';

class HomePageModel extends BaseViewModel {
  String _title = 'Home View';
  String get title => _title;
}
```

Now, go to `main.dart` and add `HomePage()` as the home widget.

```dart
import 'package:flutter/material.dart';
import 'package:stacked_app_tutorial/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacked Demo',
      home: HomePage(),
    );
  }
}
```

Run the app and you should see exactly what the image below displays:

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/00990659-d130-42dc-aa60-2b2b2403b229/Untitled.png)

That is the basics of binding a view to a ViewModel. The reasons we have this separation is to move all state and logic out of the view into the ViewModel giving you a good separation of logic and a clear guideline for where to put your logic. Each view should have it’s own ViewModel and one view should **NEVER** have two ViewModels.

## Update and Rebuild

To rebuild the UI you call `notifyListeners` in the ViewModel. Let’s make a quick, non-production example just to get the idea across. We will create a local counter variable and a function to update it and we will call `notifyListeners` when we have updated the counter. Update the `HomePageModel` to the following:

```dart
import 'package:stacked/stacked.dart';

class HomePageModel extends BaseViewModel {
  String _title = 'Home View';
  String get title => '$_title Counter: $counter';

  int _counter = 0;
  int get counter => _counter;

  void updateCounter() {
    _counter++;
    notifyListeners();
  }
}
```

Next, in the view we will add a `Floating Action` button and call the `updateCounter` function from the `onPressed`. Update the `HomePage` build function to return the following:

```dart
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePageModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Text(model.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: model.updateCounter,
          child: const Icon(
            Icons.add
          ),
        ),
      ),
      viewModelBuilder: () => HomePageModel(),
    );
  }
}
```

If you run the code now and press the floating action button you will see the text updates as the counter updates. This is the basics of the `View` to the `ViewModel` relationship and the basis of the state management of this architecture. You update a property or variable that your widget will be using, when the update is complete you call `notifyListener()` and your UI is rebuilt with the new ViewModel state. Your simulator should look like the following:

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b6392326-2c1c-4bef-a74b-5fc2276c2e12/Untitled.png)

## Navigation

For navigation we will use `get` and `auto route` to generate our routes for us. ***Please keep in mind that each of these parts of the architecture will get it’s own dedicated tutorial to cover most of the scenarios that commonly comes up while developing an application. This tutorial is dedicated only to setting up the architecture with some basic examples.*** To start off let us create a second view. We will call it `startup_page.dart`. Make sure to create this file under the `lib/pages` folder in your directory. Now, create a second file, which will be the model for StartupPage, call it `startup_view_model.dart`. Both pages should look like the following:

`startup_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'startup_view_model.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      builder: (context, model, child) => const Scaffold(
        body: Center(
          child: Text('Start Up View'),
        ),
      ),
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}
```

`startup_view_model.dart`

```dart
import 'package:stacked/stacked.dart';

class StartUpViewModel extends BaseViewModel {
  //leave empty for now
}
```

Now that we have two views we can setup `auto_route` . Open `pubspec` and add `auto_route` with the `auto_route_generator` and `build_runner` packages as a `dev_dependency` .

```dart
stacked: ^2.3.15
stacked_services:
```

In `pubspec` add

```dart
dev_dependencies:
  build_runner:
  stacked_generator:
```

Here is what the `pubspec.yaml` file should look like:

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1e5a8afe-bba2-44ae-a827-5e63e3d21861/Untitled.png)

Now, go inside the `lib` folder and create a folder called `app` . Inside that folder create a file called `app.dart` . This will contain the app wide functionality classes like the `locator`, `logger`, and `router` . Here is the code to use for `app.dart` 

```dart
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_app_tutorial/pages/home/home_page.dart';
import 'package:stacked_app_tutorial/pages/startup/startup_page.dart';

@StackedApp(routes: [
  MaterialRoute(page: StartUpPage, initial: true),
  CustomRoute(page: HomePage)
])
class App {
  // Serves no purpose yet
}
```

Now go to your `main.dart` file and add the following code:

```dart
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacked Demo',
			// this was the added navigation code
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
```

Now head over the the `startup_view_model.dart` and update the following code:

```dart
import 'package:stacked/stacked.dart';

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  String title = '';

  void doSomething() {
    title += 'new updated';
    notifyListeners();
  }
}
```

After that head back over to the `app.dart` page, and update the following code:

```dart
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_app_tutorial/pages/home/home_page.dart';
import 'package:stacked_app_tutorial/pages/startup/startup_page.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpPage, initial: true),
    CustomRoute(page: HomePage),
  ],
	// this was new
  dependencies: [
    LazySingleton(classType: NavigationService),
  ],
)
class App {
  // Serves no purpose yet
}
```

After saving the changes, you will want to run the `flutter pub run build_runner build` in the terminal and you will notice it created a new file called `app.locator.dart` . Now head back over to the `startup_view_model.dart` and import the `app.locator.dart` file. Also, make sure to change the `doSomething()` method to the following:

```dart
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_app_tutorial/app/app.locator.dart';

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  String title = '';

  void doSomething() {
    _navigationService.navigateTo(Routes.homePage);
  }
}
```

Now go update the `main.dart` file:

```dart
import 'package:flutter/material.dart';
import 'package:stacked_app_tutorial/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.router.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacked Demo',
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
```

Next, head back over to the `startup_page.dart` so we can add a button to change views:

```dart
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'startup_view_model.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: model.doSomething, child: const Icon(Icons.arrow_forward),),
        body: const Center(
          child: Text('Start Up View, click the button to go to home view'),
        ),
      ),
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}
```

After that update the `home_view_model.dart` to add a new method to change screens back to `startup_page.dart` and also make sure to update the `home_page.dart` file to add the new UI changes we made to make it look cleaner.

```dart
// home_page.dart
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePageViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(model.title),
              ElevatedButton(onPressed: model.updateCounter, child: const Text('Update Counter'))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: model.goBack,
          child: const Icon(
            Icons.arrow_back
          ),
        ),
      ),
      viewModelBuilder: () => HomePageViewModel(),
    );
  }
}
```

```dart
// home_view_model.dart
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
```

This has completed this tutorial using Stacked. You can find the repo including all files and final code below.

Link - https://github.com/jordandadams/stacked_app_tutorial