import 'package:frdemo/res/constants/appStrings.dart';
import 'package:frdemo/routes/app_routes.dart';
import 'package:frdemo/utils/permissionUtils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationUtils {
  Future<bool> handleLocationPermission() async {
    return await PermissionsUtil.checkLocationPermission();
  }

  Future<bool> getCurrentPosition(BuildContext context) async {
bool isPermissionGranted = false;
    final hasPermission = await handleLocationPermission();
    print("permission ${hasPermission},,,,,,,${!hasPermission}");

    if (!hasPermission) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              content: Text(AppStrings.permissionText),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await openAppSettings().then((value) => Navigator.pushReplacementNamed(context, AppRoutes.dashboard));
                    },
                    child: Text('OK'))
              ],
            ),
          );
        },
      );
      isPermissionGranted = false;
      // Return here when permission is not granted
     // return currentAddress;
    } else {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
              
        isPermissionGranted = true;
        print('position ::: ${position.latitude} ${position.longitude}');
      }).catchError((e) async {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled ||
            e.runtimeType == LocationServiceDisabledException) {
              isPermissionGranted = false;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext dialogContext) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: AlertDialog(
                  content:
                      Text('Please turn on the location to proceed further'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await Geolocator.getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high)
                            .then((Position position) async {
                          print(
                              'position ::: ${position.latitude} ${position.longitude}');
                         
                          isPermissionGranted = true;
                        }).catchError(
                          (e) async {
                            final serviceEnabled =
                                await Geolocator.isLocationServiceEnabled();
                            if (!serviceEnabled ||
                                e.runtimeType ==
                                    LocationServiceDisabledException) {
                                      isPermissionGranted = false;
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return WillPopScope(
                                    onWillPop: () {
                                      return Future.value(false);
                                    },
                                    child: AlertDialog(
                                      content: Text(
                                          'Location is not enabled in your device. Please enable the location to proceed further'),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pushNamed(
                                                context, AppRoutes.dashboard);
                                          },
                                          child: Text(
                                            AppStrings.ok,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.teal,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                      child: Text(
                        AppStrings.ok,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      });

      // Return here when permission is granted
      //return currentAddress;
    }
    return isPermissionGranted;
  }
}
