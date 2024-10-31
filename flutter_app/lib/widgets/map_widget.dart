import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

/// Widget to show the map location of the drone
///
/// This widget shows the current location of the drone in form of a map
/// It is made to replicate the functionality as seen in Mission Planner.
///
class MapWidget extends StatefulWidget {
  /// @brief Constructs a MapWidget widget.
  ///
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final controller = MapController(
    location: const LatLng(Angle.degree(0.0), Angle.degree(0.0)),
    zoom: 2.0,
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: MapLayout(
        controller: controller,
        builder: (context, transformer) {
          return TileLayer(
            builder: (context, x, y, z) {
              final tilesInZoom = pow(2.0, z).floor();

              while (x < 0) {
                x += tilesInZoom;
              }
              while (y < 0) {
                y += tilesInZoom;
              }

              x %= tilesInZoom;
              y %= tilesInZoom;

              //Google Maps
              final url =
                  'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

              return CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }
}
