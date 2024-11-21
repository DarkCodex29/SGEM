import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:sgem/config/api/api.maestro.detail.dart';
import 'package:sgem/config/api/api.modulo.maestro.dart';
import 'package:sgem/config/api/api.personal.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/home/home.page.dart';
import 'package:sgem/shared/modules/notfound.dart';
import 'package:sgem/shared/widgets/dropDown/dropdown.initializer.dart';
import 'package:sgem/shared/widgets/dropDown/generic.dropdown.controller.dart';

Future<void> main() async {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print(record);
      if (record.error != null) {
        // ignore: avoid_print
        print('${record.error}');
        // ignore: avoid_print
        print('${record.stackTrace}');
      }
    });
  }

  // Asegúrate de que esta es la primera línea en main()
  WidgetsFlutterBinding.ensureInitialized();

  // Get Flutter Errors
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Logger.root.severe(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    Logger.root.severe(error, stack);
    return true;
  };

  // Configura servicios y el controlador
  await initializeServices();

  // Inicia la aplicación
  runApp(const MyApp());
}

Future<void> initializeServices() async {
  final dropdownController = Get.put(GenericDropdownController());
  dropdownController.isLoadingControl.value = true;

  try {
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
  } catch (e) {
    log('Error initializing services: $e');
  } finally {
    dropdownController.completeLoading();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SGEM',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
      ],
      unknownRoute:
          GetPage(name: '/notfound', page: () => const NotFoundPage()),
      home: Obx(() {
        final dropdownController = Get.find<GenericDropdownController>();
        return dropdownController.isLoadingControl.value
            ? const Center(child: CircularProgressIndicator())
            : const HomePage(); // Muestra la HomePage cuando no está cargando
      }),
    );
  }
}
