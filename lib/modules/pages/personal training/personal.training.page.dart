import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/theme/app_theme.dart';
import 'package:sgem/modules/pages/personal%20training/personal/new.personal.controller.dart';
import 'package:sgem/modules/pages/personal%20training/personal/new.personal.page.dart';
import 'package:sgem/modules/pages/personal%20training/personal.training.controller.dart';
import 'package:sgem/modules/pages/personal%20training/training/training.personal.page.dart';
import 'package:sgem/shared/modules/maestro.detail.dart';
import 'package:sgem/shared/modules/personal.dart';
import 'package:sgem/shared/widgets/custom.dropdown.dart';
import 'package:sgem/shared/widgets/custom.textfield.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.motivo.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.confirmation.dart';
import 'package:sgem/shared/widgets/delete/widget.delete.personal.dart';

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
            controller.showNewPersonalForm.value
                ? "Nuevo personal a Entrenar"
                : controller.showEditPersonalForm.value
                    ? "Editar personal"
                    : controller.showViewPersonalForm.value
                        ? "Vizualizar"
                        : controller.showTrainingForm.value
                            ? "Entrenamientos"
                            : "Búsqueda de entrenamiento de personal",
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
        return controller.showNewPersonalForm.value ||
                controller.showEditPersonalForm.value ||
                controller.showViewPersonalForm.value
            ? _buildNewPersonalForm(controller)
            : controller.showTrainingForm.value
                ? const TrainingPersonalPage()
                : _buildSearchPage(controller);
      }),
    );
  }

  Widget _buildNewPersonalForm(PersonalSearchController controller) {
    return NuevoPersonalPage(
      isEditing: controller.showEditPersonalForm.value,
      isViewing: controller.showViewPersonalForm.value,
      personal: controller.selectedPersonal.value ??
          Personal(
            key: 0,
            tipoPersona: '',
            inPersonalOrigen: 0,
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
            guardia: Guardia(key: 0, nombre: ''),
            estado: Estado(key: 0, nombre: ''),
            eliminado: '',
            motivoElimina: '',
            usuarioElimina: '',
            apellidoPaterno: '',
            apellidoMaterno: '',
            primerNombre: '',
            segundoNombre: '',
            licenciaCategoria: '',
            gerencia: '',
            area: '',
          ),
      onCancel: () {
        controller.hideForms();
      },
    );
  }

  Widget _buildSearchPage(PersonalSearchController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildFormSection(controller, isSmallScreen),
              const SizedBox(height: 20),
              _buildResultsSection(controller, isSmallScreen),
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
        onExpansionChanged: (value) {
          controller.isExpanded.value = value;
        },
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
                          _buildDropdownGuardia(controller),
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
                          CustomDropdown(
                            hintText: "Estado",
                            options: const ["Activo", "Cesado", "Todos"],
                            isSearchable: false,
                            onChanged: (value) {},
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
                            child: _buildDropdownGuardia(controller),
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
                          CustomDropdown(
                            hintText: "Estado",
                            options: const ["Activo", "Cesado", "Todos"],
                            isSearchable: false,
                            onChanged: (value) {},
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
                            child: CustomDropdown(
                              hintText: "Estado",
                              options: const ["Activo", "Cesado", "Todos"],
                              isSearchable: false,
                              onChanged: (value) {
                                if (value == "Activo") {
                                  controller.searchPersonalEstado(95);
                                } else if (value == "Cesado") {
                                  controller.searchPersonalEstado(96);
                                } else {
                                  controller.searchPersonalEstado(null);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.clearFields,
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
                        controller.isExpanded.value = false;
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

  Widget _buildDropdownGuardia(PersonalSearchController controller) {
    return Obx(() {
      if (controller.guardiaOptions.isEmpty) {
        return const CircularProgressIndicator();
      }
      List<MaestroDetalle> options = controller.guardiaOptions;
      return CustomDropdown(
        hintText: 'Selecciona Guardia',
        options: options.map((option) => option.valor).toList(),
        selectedValue: controller.selectedGuardiaKey.value != null
            ? options
                .firstWhere((option) =>
                    option.key == controller.selectedGuardiaKey.value)
                .valor
            : null,
        isSearchable: false,
        isRequired: false,
        onChanged: (value) {
          final selectedOption = options.firstWhere(
            (option) => option.valor == value,
          );
          controller.selectedGuardiaKey.value = selectedOption.key;
          log('Guardia seleccionada - Key del Maestro: ${controller.selectedGuardiaKey.value}, Valor: $value');
        },
      );
    });
  }

  Widget _buildResultsSection(
      PersonalSearchController controller, bool isSmallScreen) {
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
          //_buildResultsTable(controller),
          // FutureBuilder para cargar los resultados automáticamente
          FutureBuilder<void>(
            future: controller.searchPersonal(
                pageNumber: controller.currentPage.value,
                pageSize: controller.rowsPerPage.value),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se busca
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Maneja errores aquí
                return Text('Error: ${snapshot.error}');
              } else {
                // Si no hay errores, muestra la tabla de resultados
                return _buildResultsTable(controller, context);
              }
            },
          ),
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
          // Acción para actualización masiva
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    return Obx(() {
      if (controller.personalResults.isEmpty) {
        return const Center(child: Text("No se encontraron resultados"));
      }
      var rowsToShow = controller.personalResults
          .take(controller.rowsPerPage.value)
          .toList();

      return DataTable(
        headingRowHeight: 40,
        columns: const [
          DataColumn(label: Text('Código MCP')),
          DataColumn(label: Text('Nombre completo')),
          DataColumn(label: Text('Documento de identidad')),
          DataColumn(label: Text('Guardia')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: rowsToShow.map((personal) {
          String estado = personal.estado.nombre;
          return DataRow(cells: [
            DataCell(Text(personal.codigoMcp)),
            DataCell(Text(personal.nombreCompleto)),
            DataCell(Text(personal.numeroDocumento)),
            DataCell(Text(personal.guardia.nombre)),
            DataCell(Row(
              children: [
                Icon(
                  Icons.circle,
                  color: estado == 'Activo' ? Colors.green : Colors.grey,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(estado),
              ],
            )),
            DataCell(Row(
              children: estado == 'Cesado'
                  ? [
                      _buildIconButton(
                          Icons.remove_red_eye, AppTheme.primaryColor, () {
                        controller.showViewPersonal(personal);
                      }),
                      _buildIconButton(
                          Icons.model_training_sharp, AppTheme.warningColor,
                          () {
                        controller.showTraining();
                      }),
                    ]
                  : [
                      _buildIconButton(Icons.edit, AppTheme.primaryColor, () {
                        controller.showEditPersonal(personal);
                      }),
                      _buildIconButton(Icons.delete, AppTheme.errorColor,
                          () async {
                        controller.selectedPersonal.value = personal;
                        String motivoEliminacion = '';

                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          enableDrag: false,
                          context: Get.context!,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () => FocusScope.of(context).unfocus(),
                              child: Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: DeleteReasonWidget(
                                  entityType: 'personal',
                                  onCancel: () {
                                    Navigator.pop(context);
                                  },
                                  onConfirm: (motivo) {
                                    motivoEliminacion = motivo;
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

                        if (controller.selectedPersonal.value != null) {
                          String? nombreCompleto =
                              controller.selectedPersonal.value!.nombreCompleto;
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            enableDrag: false,
                            context: Get.context!,
                            builder: (context) {
                              return GestureDetector(
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: ConfirmDeleteWidget(
                                    itemName: nombreCompleto,
                                    entityType: 'personal',
                                    onCancel: () {
                                      Navigator.pop(context);
                                    },
                                    onConfirm: () {
                                      confirmarEliminar = true;
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

                        NewPersonalController controllerNew =
                            Get.put(NewPersonalController());
                        controllerNew.personalData =
                            controller.selectedPersonal.value;
                        try {
                          bool success = await controllerNew.gestionarPersona(
                            accion: 'eliminar',
                            motivoEliminacion: motivoEliminacion,
                            context: Get.context!,
                          );
                          if (success) {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              enableDrag: false,
                              context: Get.context!,
                              builder: (context) {
                                return const SuccessDeleteWidget();
                              },
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Persona eliminada exitosamente."),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Get.toNamed('/buscarEntrenamiento');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Error al eliminar la persona. Intenta nuevamente."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          log('Error eliminando la persona: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error eliminando la persona: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }),
                      _buildIconButton(
                          Icons.model_training_sharp, AppTheme.warningColor,
                          () {
                        controller.showTraining();
                      }),
                      _buildIconButton(Icons.credit_card_rounded,
                          AppTheme.greenColor, () {}),
                    ],
            )),
          ]);
        }).toList(),
      );
    });
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
