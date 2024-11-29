import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../config/theme/app_theme.dart';

Future<DateTimeRange?> mostrarRangoFecha(
    BuildContext context, DateTimeRange? rangoFechaSeleccionado) async {

  final DateTime today = DateTime.now();

  if (rangoFechaSeleccionado == null) {
    //DateTimeRange
    rangoFechaSeleccionado = DateTimeRange(
      start: today.subtract(const Duration(days: 7)),
      end: today,
    );
  }

  // DateTimeRange selectedDateRange = DateTimeRange(
  //   start: today.subtract(const Duration(days: 7)),
  //   end: today,
  // );

  DateTimeRange? picked = await showDateRangePicker(
    context: context,
    initialDateRange: rangoFechaSeleccionado,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    barrierDismissible: true,
    saveText: 'Aceptar',
    helpText: 'Seleccione fechas',
    cancelText: 'Cancelar',
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppTheme.primaryColor,
            onPrimary: Colors.black,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              elevation: 3,
              foregroundColor: Colors.red, // button text color
            ),
          ),
        ),
        child: AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            child: child,
            height: 500,
            width: 400,
          ),
        ),
      );
    },
  );
  return picked;
}
