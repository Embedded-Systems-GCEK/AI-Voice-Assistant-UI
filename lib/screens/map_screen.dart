import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/app_state_provider.dart';
import '../themes/catppuccin_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(40.7829, -73.9654), // Default to NYC
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    final sensorData = provider.currentSensorData;
    
    if (sensorData != null && sensorData.latitude != null && sensorData.longitude != null) {
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(sensorData.latitude!, sensorData.longitude!),
            infoWindow: InfoWindow(
              title: 'Current Location',
              snippet: sensorData.address ?? 'Unknown address',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        };
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(sensorData.latitude!, sensorData.longitude!),
            16.0,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Map info header
              Container(
                padding: const EdgeInsets.all(16),
                color: CatppuccinColors.surface0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: CatppuccinColors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Location Tracking',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _updateMarkers();
                            provider.refreshSensorData();
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    if (provider.currentSensorData?.address != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            size: 16,
                            color: CatppuccinColors.subtext1,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              provider.currentSensorData!.address!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: CatppuccinColors.subtext1,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (provider.currentSensorData?.latitude != null &&
                        provider.currentSensorData?.longitude != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.gps_fixed,
                            size: 16,
                            color: CatppuccinColors.subtext0,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Lat: ${provider.currentSensorData!.latitude!.toStringAsFixed(6)}, '
                            'Lng: ${provider.currentSensorData!.longitude!.toStringAsFixed(6)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: CatppuccinColors.subtext0,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Map view
              Expanded(
                child: provider.currentSensorData?.latitude != null &&
                        provider.currentSensorData?.longitude != null
                    ? GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          // Apply custom map style for dark theme
                          _mapController!.setMapStyle(_getDarkMapStyle());
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            provider.currentSensorData!.latitude!,
                            provider.currentSensorData!.longitude!,
                          ),
                          zoom: 16.0,
                        ),
                        markers: _markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        compassEnabled: true,
                        mapToolbarEnabled: true,
                        zoomControlsEnabled: false,
                      )
                    : _buildNoLocationView(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateMarkers,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildNoLocationView() {
    return Container(
      color: CatppuccinColors.base,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: CatppuccinColors.overlay0,
            ),
            const SizedBox(height: 16),
            Text(
              'No Location Data Available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: CatppuccinColors.subtext1,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location data will appear here once available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CatppuccinColors.subtext0,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final provider = Provider.of<AppStateProvider>(context, listen: false);
                provider.refreshSensorData();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDarkMapStyle() {
    return '''[
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#1e1e2e"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#cdd6f4"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1e1e2e"
          }
        ]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#585b70"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#a6adc8"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#313244"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#bac2de"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#45475a"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#585b70"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#6c7086"
          }
        ]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#7f849c"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#bac2de"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#313244"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#89dceb"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#1e1e2e"
          }
        ]
      }
    ]''';
  }
}
