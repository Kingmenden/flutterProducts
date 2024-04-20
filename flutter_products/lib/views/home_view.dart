//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_products/constants.dart';
import 'package:flutter_products/src/components/body.dart';
import 'package:flutter_products/src/settings/settings_view.dart';
import 'package:flutter_products/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
//import '../src/components/store_manager.dart';
//import '../src/components/theme_manager.dart';
//import 'package:adaptive_theme/adaptive_theme.dart';

import '../src/components/theme_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _appTheme = ThemeNotifier();
  @override
  Widget build(BuildContext context) {
    //CalendarFormat _calendarFormat = CalendarFormat.month;
    //DateTime _focusedDay = DateTime.now();
    //DateTime? _selectedDay;
    //user1 = sharedPreferences.getString()
    final user = supabase.auth.currentUser;
    final padding = MediaQuery.of(context).padding;
    //final user1 = supabase.auth.getUser();
    //print('user1');
    //print(user1);
    print('user');
    print(user);
    //final fullName = user?.userMetadata?['full_name'];
    //final currentUser = supabase.auth.getUser();
    //var metadata = currentUser.user_metadata;
    //print(AdaptiveTheme.getThemeMode());
    //final AdaptiveThemeMode? savedThemeMode;
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
                  width: double.infinity, // To Change the width of DrawerHeader
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: kPrimaryColor),
                    child: Text(
                      'Operations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
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
                const Divider(),
                ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.logout_outlined),
                  onTap: () {
                    _logout();
                  },
                ),
              ],
            ),
            /*children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    backgroundBlendMode: BlendMode.darken,
                    shape: BoxShape.rectangle,
                    color: kPrimaryColor,
                  ),
                  child: Text('Operations'),
                ),
                ListTile(
                  title: const Text('All Products'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: const Text('Documents'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ]),*/
          ),
        ),
        body: const Body()
        /*body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hi $fullName'),
              const SizedBox(
                height: 30,
              ),
              /*TableCalendar(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is currently selected.
                  // If this returns true, then `day` will be marked as selected.

                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
              ),*/
              MaterialButton(
                color: Colors.red,
                onPressed: () {
                  _logout();
                },
                child: const Text('Logout'),
              )
            ],
          ),
        ),
      ),*/
        );
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
