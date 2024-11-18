import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/shared/modules/option.value.dart';
import 'package:sgem/shared/widgets/dynamic.table/dynamic.table.cabecera.dart';
import '../../../config/theme/app_theme.dart';
import '../../../shared/modules/personal.dart';
import '../../../shared/utils/pdf.view.certificado.dart';
import '../../../shared/utils/pdf.view.diploma.dart';
import '../../../shared/utils/pdf.viewer.carnet.dart';
import '../../../shared/widgets/custom.textfield.dart';
import '../../../shared/widgets/delete/widget.delete.motivo.dart';
import '../../../shared/widgets/delete/widget.delete.personal.confirmation.dart';
import '../../../shared/widgets/delete/widget.delete.personal.dart';
import '../../../shared/widgets/dropDown/custom.dropdown.global.dart';
import 'actualizacion.masiva/personal.actualizacion.masiva.page.dart';
import 'consulta.personal.controller.dart';
import 'entrenamiento/entrenamiento.personal.page.dart';
import 'personal/nuevo.personal.controller.dart';
import 'personal/nuevo.personal.page.dart';

class PersonalSearchPage extends StatelessWidget {
  const PersonalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalSearchController controller =
        Get.put(PersonalSearchController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
            controller.screen.value.descripcion(),
            style: const TextStyle(
              color: AppTheme.backgroundBlue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
        backgroundColor: AppTheme.primaryBackground,
      ),
      body: Obx(() {
        switch (controller.screen.value) {
          case PersonalSearchScreen.none:
            return _buildSearchPage(controller, context);
          case PersonalSearchScreen.newPersonal:
          case PersonalSearchScreen.viewPersonal:
          case PersonalSearchScreen.editPersonal:
            return _buildNewPersonalForm(controller);
          case PersonalSearchScreen.actualizacionMasiva:
            return PersonalActualizacionMasivaPage(
              onCancel: () {
                controller.hideForms();
              },
            );
          case PersonalSearchScreen.trainingForm:
            return EntrenamientoPersonalPage(
              controllerPersonal: controller,
              onCancel: () {
                controller.hideForms();
              },
            );
          case PersonalSearchScreen.carnetPersonal:
            return PdfToImageScreen(
                data: controller.selectedPersonal.value,
                controller: controller);
          case PersonalSearchScreen.diplomaPersonal:
            return PdfToDiplomaScreen(controller: controller);
          case PersonalSearchScreen.certificadoPersonal:
            return PdfToCertificadoScreen(controller: controller);
        }
      }),
    );
  }

  Widget _buildNewPersonalForm(PersonalSearchController controller) {
    return NuevoPersonalPage(
      isEditing: controller.screen.value == PersonalSearchScreen.editPersonal,
      isViewing: controller.screen.value == PersonalSearchScreen.viewPersonal,
      personal: controller.selectedPersonal.value ??
          Personal(
            key: 0,
            tipoPersona: '',
            inPersonalOrigen: 0,
            fechaIngresoMina: null,
            licenciaConducir: '',
            operacionMina: '',
            zonaPlataforma: '',
            restricciones: '',
            usuarioRegistro: '',
            usuarioModifica: '',
            codigoMcp: '',
            nombreCompleto: '',
            cargo: '',
            numeroDocumento: '',
            guardia: OptionValue(key: 0, nombre: ''),
            estado: OptionValue(key: 0, nombre: ''),
            eliminado: '',
            motivoElimina: '',
            usuarioElimina: '',
            apellidoPaterno: '',
            apellidoMaterno: '',
            primerNombre: '',
            segundoNombre: '',
            fechaIngreso: null,
            licenciaCategoria: '',
            licenciaVencimiento: null,
            gerencia: '',
            area: '',
          ),
      onCancel: () {
        controller.hideForms();
      },
    );
  }

  Widget _buildSearchPage(
      PersonalSearchController controller, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildFormSection(controller, isSmallScreen),
              const SizedBox(height: 20),
              _buildResultsSection(controller, isSmallScreen, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormSection(
      PersonalSearchController controller, bool isSmallScreen) {
    return Obx(() {
      return ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white),
        ),
        title: const Text(
          "Filtro de búsqueda",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: controller.isExpanded.value,
        controller: controller.expansionController,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                isSmallScreen
                    ? Column(
                        children: [
                          CustomTextField(
                            label: "Código MCP",
                            controller: controller.codigoMCPController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: "Documento de identidad",
                            controller: controller.documentoIdentidadController,
                          ),
                          const SizedBox(height: 10),
                          CustomDropdownGlobal(
                            labelText: 'Guardia',
                            dropdownKey: 'guardia',
                            hintText: 'Selecciona guardia',
                            noDataHintText: 'No se encontraron guardias',
                            controller: controller.dropdownController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: "Nombres personal",
                            controller: controller.nombresController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: "Apellidos personal",
                            controller: controller.apellidosController,
                          ),
                          const SizedBox(height: 10),
                          CustomDropdownGlobal(
                            labelText: 'Estado',
                            dropdownKey: 'estado',
                            hintText: "Selecciona estado",
                            noDataHintText: "No hay datos de estado",
                            isSearchable: false,
                            isRequired: false,
                            onChanged: (OptionValue? value) {
                              controller.dropdownController
                                  .selectValue('estado', value);
                            },
                            controller: controller.dropdownController,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "Código MCP",
                              controller: controller.codigoMCPController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: "Documento de identidad",
                              controller:
                                  controller.documentoIdentidadController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomDropdownGlobal(
                              labelText: 'Guardia',
                              dropdownKey: 'guardia',
                              hintText: 'Selecciona guardia',
                              noDataHintText: 'No se encontraron guardias',
                              controller: controller.dropdownController,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 10),
                isSmallScreen
                    ? Column(
                        children: [
                          CustomTextField(
                            label: "Nombres personal",
                            controller: controller.nombresController,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            label: "Apellidos personal",
                            controller: controller.apellidosController,
                          ),
                          const SizedBox(height: 10),
                          CustomDropdownGlobal(
                            labelText: 'Estado',
                            dropdownKey: 'estado',
                            hintText: "Selecciona estado",
                            noDataHintText: "No hay datos de estado",
                            isSearchable: false,
                            isRequired: false,
                            onChanged: (OptionValue? value) {
                              controller.dropdownController
                                  .selectValue('estadoDropdown', value);
                            },
                            controller: controller.dropdownController,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "Nombres personal",
                              controller: controller.nombresController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              label: "Apellidos personal",
                              controller: controller.apellidosController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomDropdownGlobal(
                              labelText: 'Estado',
                              dropdownKey: 'estado',
                              hintText: "Selecciona estado",
                              noDataHintText: "No hay datos de estado",
                              isSearchable: false,
                              isRequired: false,
                              onChanged: (OptionValue? value) {
                                controller.dropdownController
                                    .selectValue('estado', value);
                              },
                              controller: controller.dropdownController,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.resetControllers();
                        controller.searchPersonal();
                      },
                      icon: const Icon(
                        Icons.cleaning_services,
                        size: 18,
                        color: AppTheme.primaryText,
                      ),
                      label: const Text(
                        "Limpiar",
                        style: TextStyle(
                            fontSize: 16, color: AppTheme.primaryText),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 49, vertical: 18),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              const BorderSide(color: AppTheme.alternateColor),
                        ),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await controller.searchPersonal();
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Buscar",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 49, vertical: 18),
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildResultsSection(PersonalSearchController controller,
      bool isSmallScreen, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Personal",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (isSmallScreen)
                Column(
                  children: _buildActionButtons(controller),
                )
              else
                Row(
                  children: _buildActionButtons(controller),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.personalResults.isEmpty) {
              return const Center(
                child: Text('No se encontraron registros.'),
              );
            } else {
              return _buildResultsTable(controller, context);
            }
          }),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                    'Mostrando ${controller.currentPage.value * controller.rowsPerPage.value - controller.rowsPerPage.value + 1} - '
                    '${controller.currentPage.value * controller.rowsPerPage.value > controller.totalRecords.value ? controller.totalRecords.value : controller.currentPage.value * controller.rowsPerPage.value} '
                    'de ${controller.totalRecords.value} registros',
                    style: const TextStyle(fontSize: 14),
                  )),
              Obx(
                () => Row(
                  children: [
                    const Text("Items por página: "),
                    DropdownButton<int>(
                      value: controller.rowsPerPage.value > 0 &&
                              controller.rowsPerPage.value <= 50
                          ? controller.rowsPerPage.value
                          : null,
                      items: [10, 20, 50]
                          .map((value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.rowsPerPage.value = value;
                          controller.currentPage.value = 1;
                          controller.searchPersonal(
                              pageNumber: controller.currentPage.value,
                              pageSize: value);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: controller.currentPage.value > 1
                          ? () {
                              controller.currentPage.value--;
                              controller.searchPersonal(
                                  pageNumber: controller.currentPage.value,
                                  pageSize: controller.rowsPerPage.value);
                            }
                          : null,
                    ),
                    Text(
                        '${controller.currentPage.value} de ${controller.totalPages.value}'),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: controller.currentPage.value <
                              controller.totalPages.value
                          ? () {
                              controller.currentPage.value++;
                              controller.searchPersonal(
                                  pageNumber: controller.currentPage.value,
                                  pageSize: controller.rowsPerPage.value);
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(PersonalSearchController controller) {
    return [
      ElevatedButton.icon(
        onPressed: () {
          controller.showActualizacionMasiva();
        },
        icon: const Icon(
          Icons.refresh,
          size: 18,
          color: AppTheme.infoColor,
        ),
        label: const Text(
          "Actualización masiva",
          style: TextStyle(fontSize: 16, color: AppTheme.infoColor),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppTheme.primaryColor),
          ),
        ),
      ),
      const SizedBox(width: 10),
      ElevatedButton.icon(
        onPressed: () async {
          await controller.downloadExcel();
        },
        icon:
            const Icon(Icons.download, size: 18, color: AppTheme.primaryColor),
        label: const Text(
          "Descargar Excel",
          style: TextStyle(fontSize: 16, color: AppTheme.primaryColor),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppTheme.primaryColor),
          ),
        ),
      ),
      const SizedBox(width: 10),
      ElevatedButton.icon(
        onPressed: () {
          controller.resetControllers();
          controller.showNewPersonal();
        },
        icon:
            const Icon(Icons.add, size: 18, color: AppTheme.primaryBackground),
        label: const Text(
          "Nuevo personal",
          style: TextStyle(fontSize: 16, color: AppTheme.primaryBackground),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppTheme.primaryColor),
          ),
        ),
      ),
    ];
  }

  Widget _buildResultsTable(
      PersonalSearchController controller, BuildContext context) {
    return Obx(
      () {
        if (controller.personalResults.isEmpty) {
          return const Center(child: Text("No se encontraron resultados"));
        }

        var rowsToShow = controller.personalResults
            .take(controller.rowsPerPage.value)
            .toList();
        List<String> cabecera = [
          'Código MCP',
          'Nombre completo',
          'Documento de identidad',
          'Guardia',
          'Estado',
          'Acciones',
        ];

        return Column(
          children: [
            DynamicTableCabecera(cabecera: cabecera),
            SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: rowsToShow.map((personal) {
                    String estado = personal.estado!.nombre!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(child: Text(personal.codigoMcp!)),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(personal.nombreCompleto!),
                              Text(
                                personal.cargo!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                          Expanded(child: Text(personal.numeroDocumento!)),
                          Expanded(child: Text(personal.guardia!.nombre!)),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: estado == 'Activo'
                                      ? Colors.green
                                      : Colors.grey,
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(estado),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: estado == 'Cesado'
                                  ? [
                                      _buildIconButton(Icons.remove_red_eye,
                                          AppTheme.primaryColor, () {
                                        controller.showViewPersonal(personal);
                                      }),
                                      _buildIconButton(
                                          Icons.model_training_sharp,
                                          AppTheme.warningColor, () {
                                        controller.showTraining(personal);
                                      }),
                                    ]
                                  : [
                                      _buildIconButton(
                                          Icons.edit, AppTheme.primaryColor,
                                          () {
                                        controller.showEditPersonal(personal);
                                      }),
                                      _buildIconButton(
                                        Icons.delete,
                                        AppTheme.errorColor,
                                        () async {
                                          controller.selectedPersonal.value =
                                              personal;
                                          String motivoEliminacion = '';

                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () =>
                                                    FocusScope.of(context)
                                                        .unfocus(),
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.of(context)
                                                          .viewInsets,
                                                  child: DeleteReasonWidget(
                                                    entityType: 'personal',
                                                    onCancel: () {
                                                      Navigator.pop(context);
                                                    },
                                                    onConfirm: (motivo) {
                                                      motivoEliminacion =
                                                          motivo;
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );

                                          if (motivoEliminacion.isEmpty) {
                                            return;
                                          }

                                          bool confirmarEliminar = false;

                                          if (controller
                                                  .selectedPersonal.value !=
                                              null) {
                                            String? nombreCompleto = controller
                                                .selectedPersonal
                                                .value!
                                                .nombreCompleto;
                                            await showDialog(
                                              context: Get.context!,
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () =>
                                                      FocusScope.of(context)
                                                          .unfocus(),
                                                  child: Padding(
                                                    padding:
                                                        MediaQuery.of(context)
                                                            .viewInsets,
                                                    child: ConfirmDeleteWidget(
                                                      itemName: nombreCompleto!,
                                                      entityType: 'personal',
                                                      onCancel: () {
                                                        Navigator.pop(context);
                                                      },
                                                      onConfirm: () {
                                                        confirmarEliminar =
                                                            true;
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            log('Error: No hay personal seleccionado');
                                            return;
                                          }
                                          if (!confirmarEliminar) {
                                            return;
                                          }
                                          NuevoPersonalController
                                              controllerNew = Get.put(
                                                  NuevoPersonalController());
                                          controllerNew.personalData =
                                              controller.selectedPersonal.value;
                                          try {
                                            bool success = await controllerNew
                                                .gestionarPersona(
                                              accion: 'eliminar',
                                              motivoEliminacion:
                                                  motivoEliminacion,
                                              context: Get.context!,
                                            );
                                            if (success) {
                                              await showDialog(
                                                context: Get.context!,
                                                builder: (context) {
                                                  return const SuccessDeleteWidget();
                                                },
                                              );
                                              controller.searchPersonal();
                                            } else {
                                              ScaffoldMessenger.of(Get.context!)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Error al eliminar la persona. Intenta nuevamente."),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            log('Error eliminando la persona: $e');
                                            ScaffoldMessenger.of(Get.context!)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Error eliminando la persona: $e"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      _buildIconButton(
                                          Icons.model_training_sharp,
                                          AppTheme.warningColor, () {
                                        controller.showTraining(personal);
                                      }),
                                      _buildIconButton(
                                          Icons.credit_card_rounded,
                                          AppTheme.greenColor, () {
                                        controller.showCarnet(personal);
                                      }),
                                    ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
        size: 18,
      ),
      onPressed: onPressed,
    );
  }
}
