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