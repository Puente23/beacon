//importacion de objetos
import 'package:app_puente2/src/domain/entities/actividades.dart';
import 'package:app_puente2/src/domain/entities/opciones.dart';
import 'package:app_puente2/src/domain/entities/opciones_secundarias.dart';
import 'package:app_puente2/src/presentation/pages/screens.dart';
//importacion de funciones del manejador o gestor
import 'package:app_puente2/src/presentation/providers/data_provider.dart';
import 'package:app_puente2/src/utils/string_to_icon.dart';

//material de vistas del menu
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/input_decoration.dart';
import '../widgets/side_menu.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  static const String routerName = 'Home';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    DataProvider infoData = context.watch<DataProvider>();
    List<Widget> children = [];
    List<Widget> children2 = [];
    List<Widget> children3 = [];
    final TextEditingController _descriptionController =
        TextEditingController();

    for (var e in infoData.listOpciones) {
      if (e.estado) {
        children.add(_BotonCircularOpc(opcion: e));
      }
    }

    for (var e in infoData.listOpcionesSec) {
      if (e.estado) {
        children2.add(_BotonCircularOpcSec(opcion: e));
      }
    }

    for (var e in infoData.listActividades) {
      if (e.estado) {
        children3.add(_BotonCircularAct(opcion: e));
      }
    }

    Widget myWidget = SizedBox(
      width: double.infinity,
      height: 110,
      //color: Colors.red,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(15.0),
        shrinkWrap: true,
        children: children,
      ),
    );

    Widget myWidget2 = SizedBox(
      width: double.infinity,
      height: 110,
      //color: Colors.green,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(15.0),
        shrinkWrap: true,
        children: children2,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Actividades'),
        ),
        drawer: const SideMenu(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SelectionContainer.disabled(
              child: Text(
                'UBICACIÓN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            myWidget,
            const SizedBox(
              height: 10,
            ),
            const SelectionContainer.disabled(
              child: Text(
                'ZONA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            myWidget2,
            const SizedBox(
              height: 10,
            ),
            const SelectionContainer.disabled(
              child: Text(
                'ACTIVIDAD',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 500,
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: children3,
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'Actividad',
                          labelText: 'Estoy haciendo:',
                          prefixIcon: Icons.approval_outlined),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("data")),
                    )
                  ],
                )),
          ],
        )));
  }
}

//clases de Opciones de ubicacion, lugar en la ubicacion, Actividad en la ubicacion
class _BotonCircularOpc extends StatelessWidget {
  const _BotonCircularOpc({
    Key? key,
    required this.opcion,
  }) : super(key: key);

  final Opciones opcion;

  @override
  Widget build(BuildContext context) {
    DataProvider infoData = context.watch<DataProvider>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 80,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        onPressed: () => infoData.setListOpcionesSec(opcion.id),
        icon: Column(
          children: [
            const Icon(
              Icons.home,
              size: 35.0,
            ),
            Text(
              opcion.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonCircularOpcSec extends StatelessWidget {
  const _BotonCircularOpcSec({
    Key? key,
    required this.opcion,
  }) : super(key: key);

  final OpcionesSecundarias opcion;

  @override
  Widget build(BuildContext context) {
    DataProvider infoData = context.watch<DataProvider>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 80,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        onPressed: () => infoData.setListActividades(opcion.idOpcSec),
        icon: Column(
          children: [
            const Icon(
              Icons.home,
              size: 35.0,
            ),
            Text(
              opcion.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonCircularAct extends StatelessWidget {
  const _BotonCircularAct({
    Key? key,
    required this.opcion,
  }) : super(key: key);

  final Actividades opcion;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 80,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        onPressed: () => print('${opcion.nombre} : ${opcion.idOpcAct}'),
        icon: Column(
          children: [
            const Icon(
              Icons.home,
              size: 35.0,
            ),
            Text(
              opcion.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
