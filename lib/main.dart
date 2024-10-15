import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/home/home.page.dart';
import 'package:sgem/shared/modules/notfound.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SGEM',
      theme: AppTheme.lightTheme,
      //darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        //GetPage(name: '/buscarEntrenamiento', page: () => const PersonalSearchPage()),
      ],
      unknownRoute: GetPage(name: '/notfound', page: () => const NotFoundPage()),
      home: const HomePage(),
    );
  }
}
