import 'package:diner/core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/push_notifications/push_notif_provider.dart';
import 'package:oyt_front_core/theme/theme.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    final pushNotification = PushNotificationProvider(messengerKey: _messangerKey);
    pushNotification.setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routerProv = ref.read(routerProvider);
    return MaterialApp.router(
      scaffoldMessengerKey: _messangerKey,
      title: 'OYT - Dinner',
      routerConfig: routerProv.goRouter,
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.myTheme(),
    );
  }
}
