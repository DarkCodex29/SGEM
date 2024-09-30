import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceNavigation {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey globalKey = GlobalKey();

  static Future replaceRemoveUntil(String routeName,
      {dynamic arguments}) async {
    while (navigatorKey.currentContext!.canPop()) {
      navigatorKey.currentContext!.pop();
    }
    navigatorKey.currentContext!.replace(
      routeName,
      extra: arguments,
    );
    return;
  }

  static Future pushRemoveUntil(String routeName, {dynamic arguments}) async {
    while (navigatorKey.currentContext!.canPop()) {
      navigatorKey.currentContext!.pop();
    }
    await navigatorKey.currentContext!.push(
      routeName,
      extra: arguments,
    );
    return;
  }

  static replace(String routeName, {dynamic arguments}) {
    return navigatorKey.currentContext!.replace(
      routeName,
      extra: arguments,
    );
  }

  static Future push(String routeName, {dynamic arguments}) async {
    return await navigatorKey.currentContext!.push(
      routeName,
      extra: arguments,
    );
  }

  static goBack({dynamic result}) {
    return navigatorKey.currentContext!.pop(result);
  }

  static showLoading({String text = ""}) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      },
    );
  }
}
