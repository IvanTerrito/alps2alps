import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/location.dart';

class RideBookingProvider with ChangeNotifier {
  Location? _pickupLocation;
  Location? _dropoffLocation;
  int _passengerCount = 1;
  DateTime? _selectedDateTime;

  // Getters
  Location? get pickupLocation => _pickupLocation;
  Location? get dropoffLocation => _dropoffLocation;
  int get passengerCount => _passengerCount;
  DateTime? get selectedDateTime => _selectedDateTime;

  // Setters with notification
  void setPickupLocation(Location location) {
    _pickupLocation = location;
    notifyListeners();
  }

  void setDropoffLocation(Location location) {
    _dropoffLocation = location;
    notifyListeners();
  }

  void setPassengerCount(int count) {
    _passengerCount = count;
    notifyListeners();
  }

  void setSelectedDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

  // Validation method
  bool get isRideBookingComplete {
    return _pickupLocation != null &&
        _dropoffLocation != null &&
        _passengerCount > 0 &&
        _selectedDateTime != null;
  }

  // Reset method
  void resetBooking() {
    _pickupLocation = null;
    _dropoffLocation = null;
    _passengerCount = 1;
    _selectedDateTime = null;
    notifyListeners();
  }
}
