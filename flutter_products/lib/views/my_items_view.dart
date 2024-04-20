import 'package:flutter/material.dart';
import 'package:flutter_products/constants.dart';
import 'package:flutter_products/src/components/my_items_body.dart';
import 'package:flutter_products/src/settings/settings_view.dart';
import 'package:flutter_products/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/components/theme_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyItemsView extends StatefulWidget {
  const MyItemsView({Key? key}) : super(key: key);

  @override
  _MyItemsViewState createState() => _MyItemsViewState();
}

class _MyItemsViewState extends State<MyItemsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _appTheme = ThemeNotifier();
  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
        key: _scaffoldKey,
        appBar: buildAppBar(),
        drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: Padding(
                padding: EdgeInsets.only(bottom: padding.bottom),
                //child: ListView(
                // Important: Remove any padding from the ListView.
                //    padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 114, // To change the height of DrawerHeader
                      width: double
                          .infinity, // To Change the width of DrawerHeader
                      child: DrawerHeader(
                        decoration: BoxDecoration(color: kPrimaryColor),
                        child: Text(
                          'Operations',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Home'),
                      leading: const Icon(Icons.home_outlined),
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                    ListTile(
                      title: const Text('Profile'),
                      leading: const Icon(Icons.person_outline),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('My Items'),
                      leading: const Icon(Icons.list_outlined),
                      onTap: () {
                        Navigator.pushNamed(context, '/myItems');
                      },
                    ),
                    const Spacer(),
                    const Divider(
                      color: kPrimaryColor,
                    ),
                    ListTile(
                      title: const Text('Logout'),
                      leading: const Icon(Icons.logout_outlined),
                      onTap: () {
                        _logout();
                      },
                    ),
                  ],
                ))),
        body: const MyItemsBody());
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
          //_appTheme.toggleTheme(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            // Navigate to the settings page. If the user leaves and returns
            // to the app after it has been killed while running in the
            // background, the navigation stack is restored.
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
      ],
    );
  }

  _logout() async {
    await GetIt.I.get<SupabaseClient>().auth.signOut();

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    Navigator.pushReplacementNamed(context, '/login');
  }
}
