import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsUtil {
  static Future<bool> checkLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return true;
      } else {
        return false;
      }
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkCameraPermission() async {
    final PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    } else {
      final PermissionStatus permission = await Permission.camera.request();
      if (permission.isDenied) {
        return false;
      } else if (permission.isGranted || permission.isLimited) {
        return true;
      } else {
        return false;
      }
    }
  }
}
