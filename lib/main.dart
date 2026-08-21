import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shop/bindings/initial_bindings.dart';
import 'package:shop/config/app_env.dart';
import 'package:shop/controllers/localization_controller.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Every secret/identifier comes from .env — nothing is hard-coded.
  await AppEnv.load();

  await Firebase.initializeApp(options: AppEnv.firebaseOptions);
  await _connectEmulatorsIfEnabled();

  // Date/number symbols for every locale the app ships, so intl formatting
  // works before a locale-specific screen is opened.
  await initializeDateFormatting();

  // The locale must exist before the first frame so GetMaterialApp can read it.
  Get.put(LocalizationController(), permanent: true);

  runApp(const MyApp());
}

Future<void> _connectEmulatorsIfEnabled() async {
  if (!AppEnv.useFirebaseEmulator) return;

  final host = AppEnv.emulatorHost;
  FirebaseFirestore.instance.useFirestoreEmulator(
    host,
    AppEnv.firestoreEmulatorPort,
  );
  await FirebaseAuth.instance.useAuthEmulator(host, AppEnv.authEmulatorPort);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationController.to;

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppEnv.appName,
        theme: AppTheme.lightTheme(context),
        // Dark theme is included in the Full template
        themeMode: ThemeMode.light,
        initialBinding: InitialBindings(),
        onGenerateRoute: router.generateRoute,
        initialRoute: onbordingScreenRoute,
        locale: localization.locale,
        fallbackLocale: localization.fallbackLocale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: LocalizationController.supportedLocales,
      ),
    );
  }
}
