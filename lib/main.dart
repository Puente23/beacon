import 'package:app_puente2/src/presentation/pages/login.dart';
import 'package:app_puente2/src/presentation/pages/selecc.dart';
import 'package:app_puente2/src/presentation/providers/data_provider.dart';
import 'package:app_puente2/src/share_preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:app_puente2/src/presentation/providers/theme_provider.dart';
import 'package:app_puente2/src/presentation/pages/screens.dart';
import 'package:app_puente2/src/presentation/models/cart.dart';
import 'package:app_puente2/src/presentation/models/catalog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(isDarkmode: Preferences.isDarkmode)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => CatalogModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        //cambiar idioma
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        initialRoute: HomePage.routerName,
        routes: {
          HomePage.routerName: (_) => HomePage(),
          SettingsScreen.routerName: (_) => const SettingsScreen(),
          Sensores.routerName: (_) => const Sensores(),
          '/catalog': (context) => const MyCatalog(),
          '/cart': (context) => const MyCart(),
          '/login': (context) => const MyLogin(),
        },
        theme: Provider.of<ThemeProvider>(context).currentTheme,
      ),
    );
  }
}
