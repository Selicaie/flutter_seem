import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
   
    try {
      return await _auth.authenticateWithBiometrics(
        androidAuthStrings: AndroidAuthMessages(
          signInTitle: 'Face ID Required',
        ),
        localizedReason: 'Scan available biometrics to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      
      
    } on PlatformException catch (e) {
      return false;
    }

  }
}
 //  List<BiometricType> availableBiometrics =
    // await _auth.getAvailableBiometrics();
    //        if (availableBiometrics.contains(BiometricType.face)) {
    //     // Face ID.
    //       return await _auth.authenticateWithBiometrics(
    //         androidAuthStrings: AndroidAuthMessages(
    //           signInTitle: 'Face ID Required',
    //         ),
    //         localizedReason: 'Scan Face to Authenticate',
    //         useErrorDialogs: false,
    //         stickyAuth: false,
    //       );
    // } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
    //     // Touch ID.
    //      return await _auth.authenticateWithBiometrics(
    //       localizedReason: 'Scan your fingerprint to authenticate',
    //       useErrorDialogs: true,
    //       stickyAuth: true);
    // }