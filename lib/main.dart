import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/app_shell/presentation/app_widget.dart';
import 'package:mocl_flutter/features/app_shell/presentation/injection.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/bloc/site_type_bloc.dart';
import 'package:mocl_flutter/firebase_options.dart';
import 'package:mocl_flutter/flavors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await configureDependencies();
  unawaited(_firebase());

  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  runApp(
    BlocProvider(
      create: (_) => getIt<SiteTypeBloc>(),
      child: const AppWidget(),
    ),
  );
}

Future<void> _firebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
}
