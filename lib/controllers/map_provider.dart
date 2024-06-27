import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recycling_app/constants/app_constants.dart';
import 'package:recycling_app/helpers/image_to_bytes.dart';
import 'package:http/http.dart' as http;

class MapNotifier extends ChangeNotifier {
  Position? _initialPosition ;
  Position? get initialPosition => _initialPosition;

  final Set<Marker> markers = {};
  bool _loading = true;
  bool get loading => _loading;
  late bool _gpsEnabled;
  bool get gpsEnabled => _gpsEnabled;

  StreamSubscription? _gpsSubscription;

  MapNotifier() {
    _init();
  }

  void addMarker(Marker marker) {
    markers.add(marker);
    notifyListeners();
  }

  Future<void> _init() async {
    await _addInitialMarkers();
    _gpsEnabled = await  Geolocator.isLocationServiceEnabled();
    _loading = false;

    _gpsSubscription =  Geolocator.getServiceStatusStream().listen((status) async{
      _gpsEnabled = status == ServiceStatus.enabled;
      await _getInitialPosition();
      notifyListeners();
    });
    await _getInitialPosition();

    notifyListeners();
  }

  Future<void> _getInitialPosition() async {
    if(_gpsEnabled){
      _initialPosition = await Geolocator.getCurrentPosition();
    }
  }

  Future<void> turnOnGPS() async {
    if (!gpsEnabled) {
      await Geolocator.openLocationSettings();
    }
  }

  Future<void> _addInitialMarkers() async {
    final response = await http.get(Uri.parse('$API_URL/map_points'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> puntos = jsonData['docs'];

      final customIcon = BitmapDescriptor.fromBytes(
          await imageToBytes('assets/images/position_icon.png'));

      for (var punto in puntos) {
        LatLng position = LatLng(punto['latitud'], punto['longitud']);
        Marker marker = Marker(
          markerId: MarkerId('marker${punto['id']}'),
          position: position,
          icon: customIcon,
          infoWindow: InfoWindow(
            title: punto['nombre_punto'],
            snippet: punto['direccion'],
          ),
        );
        addMarker(marker);
      }
    } else {
      throw Exception('Failed to load markers from API');
    }
  }

  @override
  void  dispose(){
    _gpsSubscription?.cancel();
    super.dispose();
  }

}