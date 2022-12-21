import 'dart:async';
import 'dart:math';
import 'package:app_puente2/src/presentation/models/model_beacon.dart';
import 'package:app_puente2/src/presentation/pages/ubicacion.dart';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:app_puente2/src/presentation/widgets/widgets.dart';
import '../widgets/side_menu.dart';
import 'dart:io' show Platform;

class Sensores extends StatefulWidget {
  const Sensores({Key? key}) : super(key: key);
  static const String routerName = 'Sensores';
  @override
  _SensoresState createState() => _SensoresState();
}

class _SensoresState extends State<Sensores> with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final String _tag = "Beacons Plugin";
  String _beaconResult = 'Not Scanned Yet.';
  String beacondistance = 'Distancia no optima';
  String comparadorname = " ";
  int _nrMessagesReceived = 0;
  var isRunning = false;
  final List<String> _results = [];
  bool _isInForeground = true;

  final ScrollController _scrollController = ScrollController();

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS =
        const IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    beaconEventsController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Background Locations",
          message:
              "[This app] collects location data to enable [feature], [feature], & [feature] even when the app is closed or not in use");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    }

    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        print("Method: ${call.method}");
        if (call.method == 'scannerReady') {
          _showNotification("Beacons monitoring started..");
          await BeaconsPlugin.startMonitoring();
          setState(() {
            isRunning = true;
          });
        } else if (call.method == 'isPermissionDialogShown') {
          _showNotification(
              "Prominent disclosure message is shown to the user!");
        }
      });
    } else if (Platform.isIOS) {
      _showNotification("Beacons monitoring started..");
      await BeaconsPlugin.startMonitoring();
      setState(() {
        isRunning = true;
      });
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    await BeaconsPlugin.addRegion(
        "BeaconType1", "909c3cf9-fc5c-4841-b695-380958a51a5a");
    await BeaconsPlugin.addRegion(
        "BeaconType2", "6a84c716-0f2a-1ce9-f210-6a63bd873dd9");
    await BeaconsPlugin.addRegion(
        "Aruba", "4152554e-f99b-4a3b-86d0-947070693a78");
    await BeaconsPlugin.addRegion(
        "Cubeacon", "CB10023F-A318-3394-4199-A8730C7C1AEC");
    await BeaconsPlugin.addRegion(
        "AppleAirlocate", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0");
    await BeaconsPlugin.addRegion(
        "Kalops", "f7826da6-4fa2-4e98-8024-bc5b71e0893e");
    await BeaconsPlugin.addRegion(
        "RadBeaconDot", "2f234454-cf6d-4a0f-adf2-f4911ba9ffa6");

    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");

    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: 5000, foregroundBetweenScanPeriod: 10);

    BeaconsPlugin.setBackgroundScanPeriodForAndroid(
        backgroundScanPeriod: 5000, backgroundBetweenScanPeriod: 10);

    beaconEventsController.stream.listen(
        (data) {
          if (data.isNotEmpty && isRunning) {
            setState(() {
              _beaconResult = data;
              Beacon beacon = beaconFromJson(data);
              comparadorname = beacon.macAddress.toString();
              if (subir(beacon) != false) {
                if (comparadorname != beacon.macAddress) {
                  //nuevo dispositivo
                  _results.add(beacon.macAddress);
                  _nrMessagesReceived++;
                } else {
                  _results.add(beacon.macAddress);
                  _nrMessagesReceived--;
                }
              } else {
                _results.add("Dispositivo lejos:" + _beaconResult);
              }
              _nrMessagesReceived++;
            });
            Beacon beacon = beaconFromJson(data);
            if (!_isInForeground) {
              _showNotification('Beacon Encontrado: ${beacon.macAddress}');
            }
            print("Beacons DataReceived Example: $data");
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensores y Beacon'),
      ),
      drawer: const SideMenu(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Total de beacon: $_nrMessagesReceived',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF22369C),
                        fontWeight: FontWeight.bold,
                      )),
            )),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (isRunning) {
                    await BeaconsPlugin.stopMonitoring();
                  } else {
                    initPlatformState();
                    await BeaconsPlugin.startMonitoring();
                  }
                  setState(() {
                    isRunning = !isRunning;
                  });
                },
                child: Text(isRunning ? 'Alto escaneo' : 'Inicio escaneo',
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            Visibility(
              visible: _results.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _nrMessagesReceived = 0;
                      _results.clear();
                    });
                  },
                  child: const Text("Limpiar resultados",
                      style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(child: _buildResultsList())
          ],
        ),
      ),
    );
  }

  void _showNotification(String subtitle) {
    var rng = Random();
    Future.delayed(const Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'your channel id', 'your channel name',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), _tag, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }

  Widget _buildResultsList() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        controller: _scrollController,
        itemCount: _results.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          DateTime now = DateTime.now();
          String formattedDate =
              DateFormat('dd-MM-yyyy – kk:mm:ss').format(now);
          final item = ListTile(
            title: Text(
              "Fecha y hora: $formattedDate\n\n${_results[index]}",
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF1A1B26),
                    fontWeight: FontWeight.normal,
                  ),
            ),
            onLongPress: () => {
              //do something
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(data: _results[index].toString()),
                ),
              )
            },
          );
          return item;
        },
      ),
    );
  }
}

bool subir(Beacon beacon) {
  double distancia = double.parse(beacon.distance);
  bool validar = false;
  if (distancia <= 0.5) {
    validar = true;
  }
  return validar;
}

final TextEditingController _titleController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();

class DetailScreen extends StatelessWidget {
  final String data;
  const DetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Confirme para añadir"),
        ),
        body: Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              // this will prevent the soft keyboard from covering the text fields
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 20, child: Text(data)),
                SizedBox(
                  height: 20,
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Ubicacion'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: TextField(
                    controller: _descriptionController,
                    enableInteractiveSelection: false,
                    focusNode: AlwaysDisabledFocusNode(),
                    decoration: const InputDecoration(hintText: 'Mac Address'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    String newText = data;
                    final updatedText = _descriptionController.text + newText;
                    _descriptionController.value =
                        _descriptionController.value.copyWith(
                      text: updatedText,
                      selection:
                          TextSelection.collapsed(offset: updatedText.length),
                    );
                  },
                  child: const Text(
                      "Es mi dispositivo"), //id == null ? 'Create New' : 'Update'),
                ),
                ElevatedButton(
                  onPressed: () async {},
                  child: const Text(
                      "Subir beacon"), //id == null ? 'Create New' : 'Update'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Ubicacion(),
                      ),
                    );
                  },
                  child: const Text(
                      "Asignar Ubicacion"), //id == null ? 'Create New' : 'Update'),
                ),
              ]),
            )));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
