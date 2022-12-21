import 'package:app_puente2/src/data/models/opciones_models.dart';
import 'package:app_puente2/src/data/repository/info_sensor_services.dart';
import 'package:app_puente2/src/domain/entities/actividades.dart';
import 'package:app_puente2/src/domain/entities/opciones.dart';
import 'package:app_puente2/src/domain/entities/opciones_secundarias.dart';
import 'package:flutter/foundation.dart';

class DataProvider extends ChangeNotifier {
  late OpcionesModel _opcionesModel;

  List<Opciones> _listOpciones = [];
  List<OpcionesSecundarias> _listOpcionesSec = [];
  List<Actividades> _listActividades = [];

  List<Opciones> get listOpciones => _listOpciones;
  List<OpcionesSecundarias> get listOpcionesSec => _listOpcionesSec;
  List<Actividades> get listActividades => _listActividades;

  setListOpcionesSec(int value) {
    if (kDebugMode) {
      print('${_opcionesModel.opcionesSecundarias.length}');
    }
    if (kDebugMode) {
      print('value: $value');
    }
    // _listOpcionesSec.clear();
    _listOpcionesSec = _opcionesModel.opcionesSecundarias
        .where((e) => e.refencia == value)
        .toList();
    if (kDebugMode) {
      print('$_listOpcionesSec');
    }
    notifyListeners();
  }

  setListActividades(int value) {
    if (kDebugMode) {
      print('${_opcionesModel.actividades.length}');
    }
    if (kDebugMode) {
      print('value: $value');
    }
    // _listOpcionesSec.clear();
    _listActividades =
        _opcionesModel.actividades.where((e) => e.refencia == value).toList();
    if (kDebugMode) {
      print('$_listActividades');
    }
    notifyListeners();
  }

  DataProvider() {
    _opcionesModel =
        OpcionesModel(opciones: [], opcionesSecundarias: [], actividades: []);
    getListInfoSensor();
  }

  setInfoOpciones(OpcionesModel opcionesModel) {
    _opcionesModel = opcionesModel;
    setListResults();
  }

  setListResults() {
    _listOpciones = _opcionesModel.opciones;
    _listOpcionesSec = _opcionesModel.opcionesSecundarias
        .where((e) => e.refencia == _listOpciones[0].id)
        .toList();
    _listActividades = _opcionesModel.actividades
        .where((e) => e.refencia == _listOpcionesSec[0].idOpcSec)
        .toList();
  }

  getListInfoSensor() async {
    var response = await InfoSensorServices.loadStudent();
    setInfoOpciones(response as OpcionesModel);
    notifyListeners();
  }
}
