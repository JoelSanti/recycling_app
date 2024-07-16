import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recycling_app/controllers/map_provider.dart';

class RecyclingPoints extends StatefulWidget {
  // ignore: use_super_parameters
  const RecyclingPoints({Key? key}) : super(key: key);

  @override
  State<RecyclingPoints> createState() => _RecyclingPointsState();
}

class _RecyclingPointsState extends State<RecyclingPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Puntos de reciclaje', style: TextStyle(fontSize: 19)),
            Image.asset('assets/images/logo_huanuco.png', height: 25),
          ],
        ),
      ),
      body: Selector<MapNotifier, bool>(
          selector: (_, notifier) => notifier.loading,
          builder: (_, loading, loadingWidget) {
            if (loading) {
              return loadingWidget!;
            }
            return Consumer<MapNotifier>(
              builder: (context, mapNotifier, gpsMessageWidget) {
                if (!mapNotifier.gpsEnabled) {
                  return gpsMessageWidget!;
                }

                final initialPosition = LatLng( mapNotifier.initialPosition!.latitude ,  mapNotifier.initialPosition!.longitude);

                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialPosition,
                    zoom: 16,
                  ),
                  markers: mapNotifier.markers,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  myLocationEnabled: true,
                );
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('GPS desactivado'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MapNotifier>().turnOnGPS();
                      },
                      child: const Text('Activar GPS'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Center(
            child: CircularProgressIndicator(),
          )),
    );
  }
}
