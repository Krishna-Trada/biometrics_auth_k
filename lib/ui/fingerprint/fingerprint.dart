import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:local_auth/local_auth.dart';

class Fingerprint extends ConsumerStatefulWidget {
  const Fingerprint({Key? key}) : super(key: key);

  @override
  ConsumerState<Fingerprint> createState() => _FingerprintState();
}

class _FingerprintState extends ConsumerState<Fingerprint> {

  final LocalAuthentication auth = LocalAuthentication();

  ///Init
  @override
  void initState() {
    super.initState();
    checkBiometrics();
    getBiometicsAvailable();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  /// canCheckBiometrics only indicates whether hardware support is available, not whether the device has any biometrics enrolled
  Future<void> checkBiometrics() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    debugPrint(canAuthenticate.toString());
  }

  Future<void> getBiometicsAvailable() async {
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    debugPrint(availableBiometrics.toString());

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
      debugPrint('is not empty');
    }

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.face)) {
      // Specific types of biometrics are available.
      // Use checks like this with caution!
    }
  }

  ///Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint'),
      ),
    );
  }
}
