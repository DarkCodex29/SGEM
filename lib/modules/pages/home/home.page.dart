import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/capacitaciones/capacitacion.page.dart';
import 'package:sgem/shared/widgets/widget.perfil.dart';

import '../administracion/administracion.page.dart';
import '../consulta.entrenamiento/consulta.entrenamiento.page.dart';
import '../consulta.personal/consulta.personal.page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int selectedIndex = 0;

  OverlayEntry? _overlayEntry;

  @override
  bool get wantKeepAlive => true;

  void _showPerfilOverlay(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return const Positioned(
          top: 80,
          child: Material(
            color: Colors.transparent,
            child: PerfilWidget(),
          ),
        );
      },
    );
    overlayState.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;
    bool isSmallScreen = screenWidth <= 400;
    bool isHome = selectedIndex == 0;

    final List<Widget> pages = [
      _buildHomeContent(isLargeScreen, isSmallScreen),
      const PersonalSearchPage(),
      const Center(child: Text("Búsqueda de Monitoreos")),
      CapacitacionPage(onCancel: () {}),
      ConsultaEntrenamientoPage(),
      const AdministracionPage(),
    ];

    return Scaffold(
      appBar: _buildAppBar(isSmallScreen),
      drawer:
          isHome || !isLargeScreen ? Drawer(child: _buildDrawerItems()) : null,
      body: Row(
        children: [
          if (!isHome && isLargeScreen) Drawer(child: _buildDrawerItems()),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(bool isSmallScreen) {
    return AppBar(
      backgroundColor: AppTheme.backgroundBlue,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Row(
        children: [
          if (!isSmallScreen)
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
          if (!isSmallScreen) const SizedBox(width: 10),
          Expanded(
            child: Text(
              isSmallScreen ? 'GEM' : 'Gestión de Entrenamiento Mina',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 16 : 20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            InkWell(
              onTap: () {
                _showPerfilOverlay(context);
              },
              child: const Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Felipe Cordova',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        'Administrador',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/user_avatar.png'),
                    radius: 18,
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDrawerItems() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        if (selectedIndex == 0)
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.backgroundBlue,
            ),
            child: Image.asset(
              'assets/images/logo.png',
              height: 50,
            ),
          ),
        _buildDrawerItem(Icons.home, 'Inicio', 0),
        _buildDrawerItem(Icons.search, 'Búsqueda de Entrenamiento Personal', 1),
        _buildDrawerItem(Icons.monitor, 'Búsqueda de Monitoreos', 2),
        _buildDrawerItem(Icons.book, 'Búsqueda de Capacitaciones', 3),
        _buildDrawerItem(Icons.school, 'Consultar Entrenamiento', 4),
        _buildDrawerItem(Icons.settings, 'Administración', 5),
      ],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    bool isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accent1.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            if (selectedIndex == 0 ||
                MediaQuery.of(context).size.width <= 800) {
              Get.toNamed('/buscarEntrenamiento');
              //Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildHomeContent(bool isLargeScreen, bool isSmallScreen) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 40 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '¡Bienvenido al Sistema de Gestión de Entrenamiento Mina!',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryText),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nos complace recibirte en nuestra plataforma, dedicada a la formación y desarrollo de nuestros colaboradores. Este sistema está diseñado para proporcionarte las herramientas y recursos necesarios para garantizar tu crecimiento profesional y asegurar el cumplimiento de los más altos estándares de seguridad y eficiencia en nuestras operaciones.',
                    style: TextStyle(
                        fontSize: 16, color: AppTheme.primaryText, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Wrap(
                spacing: isLargeScreen ? 24 : 12,
                runSpacing: isLargeScreen ? 24 : 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildCard('Búsqueda de entrenamiento de personal',
                      Icons.people, Colors.blue, Colors.blueAccent),
                  _buildCard('Consulta de entrenamientos', Icons.school,
                      Colors.lightBlue, Colors.lightBlueAccent),
                  _buildCard('Búsqueda de monitoreos', Icons.monitor,
                      Colors.teal, Colors.tealAccent),
                  _buildCard('Búsqueda de capacitaciones', Icons.book,
                      Colors.orange, Colors.deepOrangeAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color1, Color color2) {
    return SizedBox(
      width: 250,
      height: 170,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 10,
              right: 10,
              child: Icon(
                Icons.trending_up,
                size: 60,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(
                      icon,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
