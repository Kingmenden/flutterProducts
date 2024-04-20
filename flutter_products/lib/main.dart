import 'package:flutter/material.dart';
import 'package:flutter_products/src/settings/settings_view.dart';
import 'package:flutter_products/views/add_product_view.dart';
import 'package:get_it/get_it.dart';
import 'src/app.dart';
import 'src/components/theme_manager.dart';
//import 'src/settings/settings_controller.dart';
//import 'src/settings/settings_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:supabase/supabase.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_products/constants.dart';

//import 'components/theme_manager.dart';
//import 'settings/settings_controller.dart';
//import 'settings/settings_view.dart';
import 'package:flutter_products/views/home_view.dart';
import 'package:flutter_products/views/login_view.dart';
import 'package:flutter_products/views/register_view.dart';
import 'package:flutter_products/views/splash_view.dart';

import 'src/sample_feature/sample_item_details_view.dart';
import 'src/sample_feature/sample_item_list_view.dart';
import 'views/my_items_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt locator = GetIt.instance;

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  //final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  //await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(//ChangeNotifierProvider<ThemeNotifier>(
      //create: (_) => ThemeNotifier(),
      //child: const MyApp(
      //  theme: null,
      //),
      //)
      const MyApp());
}

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appTheme = ThemeNotifier();

  @override
  void initState() {
    super.initState();
    _appTheme.addListener(() => setState(() {}));
  }

  //final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    //listenable: settingsController,
    return MaterialApp(
      title: 'Products App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: const SplashView(),
      routes: {
        //'/': (_) => const SplashView(),
        '/login': (_) => const LoginView(),
        '/register': (_) => const RegisterView(),
        '/home': (_) => const HomeView(),
        '/myItems': (_) => const MyItemsView(),
        '/addProduct': (_) => const AddProductView(),
        '/settings': (_) => const SettingsView(),
      },
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],

      // Use AppLocalizations to configure the correct application title
      // depending on the user's locale.
      //
      // The appTitle is defined in .arb files found in the localization
      // directory.
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,

      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      // SettingsController to display the correct theme.
      theme: _appTheme.lightTheme,
      darkTheme: _appTheme.darkTheme,
      themeMode: _appTheme.themeMode,
      //themeMode: settingsController.themeMode,

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              //case SettingsView.routeName:
              //return SettingsView(controller: settingsController);
              case SampleItemDetailsView.routeName:
                return const SampleItemDetailsView();
              case SampleItemListView.routeName:
              default:
                return const SampleItemListView();
            }
          },
        );
      },
    );
  }
}
