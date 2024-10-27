import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.controller.dart';
import 'package:sgem/modules/pages/monitoring/controllers/monitoring.page.controller.dart';
import 'package:sgem/modules/pages/monitoring/widget/form.monitoring.dart';
import 'package:sgem/modules/pages/monitoring/widget/info.person.monitoring.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';

class CreateMonioringView extends StatelessWidget {
  const CreateMonioringView({
    super.key,
    required this.controller,
    this.isEditing = false,
    this.isViewing = false,
  });
  final MonitoringSearchController controller;
  final bool isEditing;
  final bool isViewing;
  @override
  Widget build(BuildContext context) {
    final CreateMonitoringController createMonitoringController =
        Get.put(CreateMonitoringController());
    return LayoutBuilder(builder: (context, constraints) {
      bool isSmallScreen = constraints.maxWidth < 600;
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nuevo Monitoreo",
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.backgroundBlue),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child: CustomTextField(
                            label: "Código MCP",
                            controller:
                                createMonitoringController.codigoMCPController,
                            icon: Obx(() {
                              return createMonitoringController
                                      .isLoadingCodeMcp.value
                                  ? const CupertinoActivityIndicator(
                                      radius: 10,
                                      color: Colors.grey,
                                    )
                                  : const Icon(Icons.search);
                            }),
                            isReadOnly: isEditing || isViewing,
                            onIconPressed: () {
                              if (!createMonitoringController
                                      .isLoadingCodeMcp.value &&
                                  !isEditing &&
                                  !isViewing) {
                                createMonitoringController
                                    .searchPersonByCodeMcp();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InfoPersonMonitoringWidegt(
                          isSmallScreen: isSmallScreen,
                          createMonitoringController:createMonitoringController
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FormMonitoringWidget(
                          isSmallScreen: isSmallScreen,
                          monitoringSearchController: controller,
                          isEditing: isEditing,
                          createMonitoringController:
                              createMonitoringController,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
