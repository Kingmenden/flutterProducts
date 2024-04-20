import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_products/constants.dart';
import 'package:flutter_products/src/sample_feature/sample_item.dart';
import 'package:flutter_products/src/sample_feature/sample_item_details_view.dart';
import 'package:flutter_products/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class MyItemsBody extends StatefulWidget {
  final List<SampleItem> products;

  const MyItemsBody(
      {super.key,
      this.products = const [SampleItem(1), SampleItem(2), SampleItem(3)]});

  @override
  _MyItemsBodyState createState() => _MyItemsBodyState();
}

class _MyItemsBodyState extends State<MyItemsBody> {
  List<SampleItem> products = [SampleItem(1), SampleItem(2), SampleItem(3)];
  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'];
    var name = fullName.toString().split(' ');
    var firstName = name.first;

    Size size = MediaQuery.of(context).size;

    return Column(children: <Widget>[
      Container(
          height: size.height * 0.2,
          child: Stack(children: <Widget>[
            Container(
                padding: const EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: 36 + kDefaultPadding),
                height: size.height * 0.2 - 57,
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36))),
                child: Row(
                  children: <Widget>[
                    Text('My Products',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outlined),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, '/addProduct');
                      },
                    )
                  ],
                )),
            Positioned(
                bottom: 32,
                left: 00,
                right: 0,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  height: 54,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 10),
                            blurRadius: 50,
                            color: kPrimaryColor.withOpacity(0.23))
                      ]),
                  child: TextField(
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        hintText: "Find Product",
                        hintStyle: TextStyle(
                          color: kPrimaryColor.withOpacity(0.5),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ))
          ])),
      Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          // Providing a restorationId allows the ListView to restore the
          // scroll position when a user leaves and returns to the app after it
          // has been killed while running in the background.
          restorationId: 'MyItemsView',
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            final product = products[index];

            return ListTile(
                title: Text('Product ${product.id}'),
                //leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                //foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                //),
                onTap: () {
                  // Navigate to the details page. If the user leaves and returns to
                  // the app after it has been killed while running in the
                  // background, the navigation stack is restored.
                  Navigator.restorablePushNamed(
                    context,
                    SampleItemDetailsView.routeName,
                  );
                });
          },
        ),
      )
    ]);
  }
}
