import 'package:coin_box_test/routes/app_router.dart';
import 'package:coin_box_test/theming/app_theme.dart';
import 'package:coin_box_test/utils/app_dio_client.dart';
import 'package:coin_box_test/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppLogger.instance.initializeAppLogger();
  await AppDioClient.instance.initializeDio();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = createRouter();

    return MaterialApp.router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().appThemeData,
    );
  }
}

