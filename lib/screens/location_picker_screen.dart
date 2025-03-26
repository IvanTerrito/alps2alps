import 'package:flutter/material.dart';
import 'package:ivan_territo_alps2alps/core/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/location.dart';
import '../providers/ride_booking_provider.dart';
import '../services/geocoding_service.dart';

final Location _defaultLocation = Location(LatLng(38.115688, 13.361463), "");

class LocationPickerScreen extends StatefulWidget {
  final bool isPickup;

  const LocationPickerScreen({super.key, required this.isPickup});

  @override
  LocationPickerScreenState createState() => LocationPickerScreenState();
}

class LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _addressController = TextEditingController();

  late Location _selectedLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Get the current location from the provider based on isPickup
    final provider = Provider.of<RideBookingProvider>(context, listen: false);
    _selectedLocation = widget.isPickup
        ? provider.pickupLocation ?? _defaultLocation
        : provider.dropoffLocation ?? _defaultLocation;

    // Set the initial address in the text field
    _addressController.text = _selectedLocation.address;
  }

  void _searchAndMoveToAddress() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final location = await GeocodingService.getLocationFromAddress(address);

      if (location != null) {
        setState(() {
          _selectedLocation = location;
          _isLoading = false;
        });

        // Animating the camera to the new location
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: location.position, zoom: 16),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not find location for: $address')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPickup
            ? 'Select Pick-up Location'
            : 'Select Drop-off Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation.position,
              zoom: _selectedLocation.position == _defaultLocation.position
                  ? 14
                  : 16,
            ),
            onTap: (location) async {
              setState(() {
                _isLoading = true;
              });

              try {
                Location tempLocation =
                    await GeocodingService.getAddressFromLocation(location) ??
                        Location(location, "");

                setState(() {
                  _selectedLocation = tempLocation;
                  _addressController.text = tempLocation.address;
                  _isLoading = false;
                });
              } catch (e) {
                setState(() {
                  _selectedLocation = Location(location, "");
                  _addressController.text = "";
                  _isLoading = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error fetching address: $e')),
                );
              }
            },
            markers: {
              Marker(
                markerId: MarkerId('selected_location'),
                position: _selectedLocation.position,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  widget.isPickup
                      ? BitmapDescriptor.hueAzure
                      : BitmapDescriptor.hueRed,
                ),
              ),
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  readOnly: _isLoading,
                  controller: _addressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: _isLoading
                        ? 'Loading...'
                        : (_selectedLocation.address.isNotEmpty
                            ? _selectedLocation.address
                            : 'Enter address'),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _isLoading ? null : _searchAndMoveToAddress,
                    ),
                  ),
                  onSubmitted: (_) => _searchAndMoveToAddress(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 64, 16),
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          final provider = Provider.of<RideBookingProvider>(
                              context,
                              listen: false);

                          // Set either pickup or dropOff location based on the parameter
                          if (widget.isPickup) {
                            provider.setPickupLocation(_selectedLocation);
                          } else {
                            provider.setDropoffLocation(_selectedLocation);
                          }

                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: widget.isPickup ? PCBlue : PCRed,
                  ),
                  child: Text(_isLoading ? 'LOADING...' : 'CONFIRM LOCATION'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
