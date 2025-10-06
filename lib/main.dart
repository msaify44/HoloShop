import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:holo_shop/core/di/injection_container.dart';
import 'package:holo_shop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:holo_shop/features/product_listing/presentation/screens/products_listing_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'generated/l10n.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      
      // Initialize dependency injection
      await initializeDependencies();
      
      // Set up Flutter error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        debugPrint('Flutter error: ${details.exception}');
        debugPrint('Stack trace: ${details.stack}');
      };
      
      runApp(const MyApp());
    },
    (error, stackTrace) {
      // Handle uncaught errors
      debugPrint('Uncaught error: $error');
      debugPrint('Stack trace: $stackTrace');
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartBloc>(),
      child: MaterialApp(
        locale: _locale,
        onGenerateTitle: (context) => S.of(context).appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: ProductsListingScreen(
          onLanguageChanged: _changeLanguage,
        ),
      ),
    );
  }
}