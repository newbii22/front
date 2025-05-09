import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  final LatLng _center = const LatLng(37.550631, 127.074073);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _goToCurrentLocation() async {
    Location location = Location();
    bool servicedEnable = await location.serviceEnabled();
    
    if (!servicedEnable) {
      servicedEnable = await location.requestService();
      if (!servicedEnable) {
        print("위치활성화ㄴㄴ");
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('권한ㄴㄴ');
        return;
      }
    }

    try {
      final currentLocation = await location.getLocation();
      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                currentLocation.latitude!, currentLocation.longitude!),
            zoom: 15.0,
          ),
        ),
      );
    } catch(e){
      print('위치못가져옴!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
          myLocationEnabled: true,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location),
          )
        )
      ],
    );
  }
}
