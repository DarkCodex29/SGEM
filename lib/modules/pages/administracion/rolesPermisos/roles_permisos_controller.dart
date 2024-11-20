import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sgem/config/api/api.roles.permisos.dart';

class RolesPermisosController extends GetxController  with GetSingleTickerProviderStateMixin  {
 // RolesPermisosController({
 //   MaestroService? maestroService,
 //   MaestroDetalleService? maestroDetalleService,
 // })  : _maestroService = maestroService ?? MaestroService(),
 //       _maestroDetalleService =
 //           maestroDetalleService ?? MaestroDetalleService();
  late TabController tabControllerForRolesPermisos;
  List<RolToList> listForStaticInfo = [
    RolToList(
      name: "name", 
      state: true, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    RolToList(
      name: "name1", 
      state: true, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    RolToList(
      name: "name2", 
      state: false, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    RolToList(
      name: "name3", 
      state: true, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    RolToList(
      name: "name4", 
      state: true, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    RolToList(
      name: "name5", 
      state: false, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    )
  ];

  List<Permisos> listEstaticForPermission = [
    Permisos(
    codePermission:"codePermission",
      name: "name", 
      state: true, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    Permisos(
    codePermission:"codePermission",
      name: "name1", 
      state: true, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    Permisos(
    codePermission:"codePermission",
      name: "name2", 
      state: false, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    Permisos(
    codePermission:"codePermission",
      name: "name3", 
      state: true, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    Permisos(
    codePermission:"codePermission",
      name: "name4", 
      state: true, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    ),
    Permisos(
      codePermission: "codePermission",
      name: "name5", 
      state: false, 
      userRegister: "userRegister", 
      dateRegister: "dateRegister",
      idRegister: "0"
    )
  ];

  @override
  Future<void> onInit() async {
    tabControllerForRolesPermisos = TabController(initialIndex: 0, length: 3, vsync: this);
    super.onInit();
  }


//
 // final MaestroService _maestroService;
 // final MaestroDetalleService _maestroDetalleService;
//
 // final GenericDropdownController dropdownController =
 //     Get.find<GenericDropdownController>
}
