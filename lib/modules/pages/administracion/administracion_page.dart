import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/administracion/administracion.dart';

class AdministracionPage extends StatelessWidget {
  const AdministracionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdministracionController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Obx(
            () => Text(
              controller.screenPage.value.pageName,
              style: const TextStyle(
                color: AppTheme.backgroundBlue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: AppTheme.primaryBackground,
      ),
      body: ColoredBox(
        color: Colors.white,
        child: Obx(
          () => switch (controller.screenPage.value) {
            AdministracionScreen.none => const AdministracionView(),
            AdministracionScreen.maestro => const MaestroPage()
          },
        ),
      ),
    );
  }
}

class AdministracionView extends StatelessWidget {
  const AdministracionView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        children: [
          _ExpansionTile(
            title: 'Mantenimientos generales',
            children: [
              _Button(
                icon: Icons.key,
                label: 'Maestro',
                toPage: AdministracionScreen.maestro,
              ),
              _Button(
                icon: Icons.view_module_rounded,
                label: 'Modulo',
              ),
              _Button(
                icon: Icons.business_rounded,
                label: 'Empresa capacitadora',
              ),
              _Button(
                icon: Icons.calendar_month,
                label: 'Cronograma de fechas disponibles',
              ),
            ],
          ),
          SizedBox(height: 20),
          _ExpansionTile(
            title: 'Seguridad',
            children: [
              _Button(
                icon: Icons.security,
                label: 'Roles y Permisos',
              ),
              _Button(
                icon: Icons.person,
                label: 'Usuarios',
              ),
              _Button(
                icon: Icons.history,
                label: 'Consulta de historial de modificaciones del sistema',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.icon,
    this.toPage,
  });

  final AdministracionScreen? toPage;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: toPage == null
          ? () {}
          : () => Get.find<AdministracionController>().changePage(toPage!),
      icon: Icon(
        icon,
        size: 18,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 24,
        ),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }
}

class _ExpansionTile extends StatelessWidget {
  const _ExpansionTile({
    required this.children,
    required this.title,
  });

  final List<Widget> children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
