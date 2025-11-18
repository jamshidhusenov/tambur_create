import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tambur_create/core/di/setup_locator.dart';
import 'package:tambur_create/core/network/connectivity_service.dart';
import 'package:tambur_create/core/network/connectivity_widget.dart';
import 'package:tambur_create/core/services/observer.dart';
import 'package:tambur_create/features/otk/domain/use_cases/otk_use_case.dart';
import 'package:tambur_create/features/otk/presentation/manager/otk_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tambur_create/config/routes/routes.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      await setupLocator();
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
      await Hive.openBox('login');
      Bloc.observer = MyBlocObserver();
      runApp(const MyApp());
    },
    (error, stack) {
      // Log the error to the console
      debugPrint('❌ Kutilmagan xato ushlandi: $error');
      debugPrint('❌ Stack trace: $stack');
      // FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OtkBloc>(
          create: (context) => OtkBloc(otkUseCase: locator<OtkUseCase>()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            title: 'Profpact',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            // Initialize FlutterSmartDialog with builder method
            builder: FlutterSmartDialog.init(
              builder: (context, child) {
                // Apply ConnectivityAwareWidget
                return ConnectivityAwareWidget(
                  connectivityService: locator<ConnectivityService>(),
                  child: child!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
