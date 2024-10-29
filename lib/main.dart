import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/home/home.page.dart';
import 'package:sgem/shared/modules/notfound.dart';
import 'package:sgem/shared/widgets/dropDown/dropdown.initializer.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

void main() async {
  final dropdownController = Get.put(GenericDropdownController());
  final maestroDetalleService = MaestroDetalleService();
  final moduloMaestroService = ModuloMaestroService();
  final personalService = PersonalService();

  final dropdownInitializer = DropdownDataInitializer(
    dropdownController: dropdownController,
    maestroDetalleService: maestroDetalleService,
    moduloMaestroService: moduloMaestroService,
    personalService: personalService,
  );

  await dropdownInitializer.initializeAllDropdowns();
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
      unknownRoute:
          GetPage(name: '/notfound', page: () => const NotFoundPage()),
      home: const HomePage(),
    );
  }
}
