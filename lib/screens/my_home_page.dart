import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

import '../widgets/costume_cart.dart';

import '../widgets/favorite_product_details.dart';

import '../widgets/product_details.dart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static const routeName = '/';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int initialPage = 0;

  bool showFavorites = false;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: pageIndex,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Relax Shop'),
          actions: const [
            CostumeCart(),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                toolbarHeight: 80,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: const Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sevimli Buyurtmangizni tanlang',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Ajoyiblik har bir buyumda mujassam',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(65),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 7,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(
                          color: Colors.transparent,
                        )),
                        onTap: (ind) {
                          setState(() {
                            initialPage = ind;
                            showFavorites = initialPage != 0;
                          });
                        },
                        splashFactory: NoSplash.splashFactory,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(text: 'Barchasi'),
                          Tab(text: 'Sevimli'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: const Padding(
            padding:  EdgeInsets.only(top: 10.0, left: 10, right: 10),
            child: TabBarView(
              children: [
                ProductDetails(),
                FavoriteProductDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
