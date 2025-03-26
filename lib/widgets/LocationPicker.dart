import 'package:flutter/material.dart';
import 'package:ivan_territo_alps2alps/core/constants/colors.dart';
import 'package:ivan_territo_alps2alps/providers/ride_booking_provider.dart';

import '../models/location.dart';
import '../screens/location_picker_screen.dart';

class LocationPicker extends StatefulWidget {
  final RideBookingProvider provider;
  final Location? pickupLocation;
  final Location? dropOffLocation;
  final Function() onSwitchLocations;
  final Function(bool isPickup) onLocationTap;

  const LocationPicker({
    super.key,
    required this.provider,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.onSwitchLocations,
    required this.onLocationTap,
  });

  @override
  LocationPickerState createState() => LocationPickerState();
}

class LocationPickerState extends State<LocationPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _switchController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _switchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create rotation animation
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _switchController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _switchController.dispose();
    super.dispose();
  }

  void _handleSwitchTap() {
    // Trigger rotation animation
    _switchController.forward(from: 0);

    // Call the provided switch function
    widget.onSwitchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PCBlue.withValues(alpha: 0.2),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          spacing: 10,
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PCBlue.withValues(alpha: 0.5),
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 80,
                  color: PCBlue.withValues(alpha: 0.5),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PCRed.withValues(alpha: 0.5),
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LocationPickerScreen(isPickup: true),
                      ),
                    );
                    if (result != null) {
                      widget.provider.setPickupLocation(result);
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 300,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PICK-UP',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        widget.provider.pickupLocation != null
                            ? Text(widget.provider.pickupLocation!.address != ''
                                ? widget.provider.pickupLocation!.address
                                : 'Location selected')
                            : Text('Select your pick-up point')
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 250,
                      height: 1,
                      color: PCBlue.withValues(alpha: 0.5),
                    ),
                    GestureDetector(
                      onTap: widget.pickupLocation != null &&
                              widget.dropOffLocation != null
                          ? _handleSwitchTap
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'You have to fill both the locations to be able to switch them'),
                                ),
                              );
                            },
                      child: RotationTransition(
                        turns: _rotationAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: PCBlue.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LocationPickerScreen(isPickup: false),
                      ),
                    );
                    if (result != null) {
                      widget.provider.setDropoffLocation(result);
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 300,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DROP-OFF',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        widget.provider.dropoffLocation != null
                            ? Text(
                                widget.provider.dropoffLocation!.address != ''
                                    ? widget.provider.dropoffLocation!.address
                                    : 'Location selected')
                            : Text('Select your drop-off point')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
