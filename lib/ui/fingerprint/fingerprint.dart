import 'package:biometrics_auth_k/ui/fingerprint/failure.dart';
import 'package:biometrics_auth_k/ui/fingerprint/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
// import 'package:local_auth_android/local_auth_android.dart';
// import 'package:local_auth_ios/local_auth_ios.dart';


class Fingerprint extends ConsumerStatefulWidget {
  const Fingerprint({Key? key}) : super(key: key);

  @override
  ConsumerState<Fingerprint> createState() => _FingerprintState();
}

class _FingerprintState extends ConsumerState<Fingerprint> {

  final LocalAuthentication auth = LocalAuthentication();
  bool isSupported = false;
  bool? didAuthenticate;

  ///Init
  @override
  void initState() {
    super.initState();

    // authenticate();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await checkBiometrics();
      await getBiometicsAvailable();
    });
  }

  /// canCheckBiometrics only indicates whether hardware support is available, not whether the device has any biometrics enrolled
  Future<void> checkBiometrics() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    debugPrint(canAuthenticate.toString());
  }

  /// to get available biometrics
  Future<void> getBiometicsAvailable() async {
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    debugPrint(availableBiometrics.toString());

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
      isSupported = true;
    }

  }

  /// authentication method
  Future<bool?> authenticate() async {
    try {
      didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show nothing',
          options: const AuthenticationOptions(biometricOnly: true),
          /*authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Oops! Biometric authentication required!',
              cancelButton: 'No thanks',
            ),
            IOSAuthMessages(
              cancelButton: 'No thanks',
            ),
          ]*/
      );
      debugPrint('did authenticate is $didAuthenticate');
      // ···
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        debugPrint('auth error not available');
        // Add handling of no hardware here.
      } else if (e.code == auth_error.notEnrolled) {
        debugPrint('auth error not enrolled');
        // ...
      } else {
        // ...
      }
    }
    return didAuthenticate;
  }

  void showSnackbar(){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fingerprint is not supported in your Device.')));
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
      body: const Center(
        child: Text(
          'Please Press Refresh button to authenticate.',style: TextStyle(
          fontSize: 16
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(isSupported) {
            authenticate().then((value) {
              if(value == null){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Failure(),));
                // print('null');
              }
              else if(value){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Success(),));
              }
              else{
                debugPrint('It fails to authenticate.');
              }
            });

          }
          else{
            showSnackbar();
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
