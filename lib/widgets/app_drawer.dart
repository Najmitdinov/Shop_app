import 'package:flutter/material.dart';

import '../screens/manage_product_screen.dart';
import '../screens/my_home_page.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static Widget listItem(IconData icon, String title, Function() handler) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: handler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('MENU'),
            automaticallyImplyLeading: false,
          ),
          listItem(
            Icons.home,
            'Asosiy Sahifa',
            () => Navigator.of(context)
                .pushReplacementNamed(MyHomePage.routeName),
          ),
          const Divider(
            height: 0,
          ),
          listItem(
            Icons.payment,
            'Buyurtmalar Sahifasi',
            () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(
            height: 0,
          ),
          listItem(
            Icons.settings,
            'Mahsulotlar Sahifasi',
            () => Navigator.of(context)
                .pushReplacementNamed(ManageProductScreen.routeName),
          ),
        ],
      ),
    );
  }
}
