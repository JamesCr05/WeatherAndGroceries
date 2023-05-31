import 'package:flutter/material.dart';

class ReusableDrawer extends StatefulWidget {
  const ReusableDrawer({Key? key}) : super(key: key);

  @override
  State<ReusableDrawer> createState() => _ReusableDrawerState();
}

class _ReusableDrawerState extends State<ReusableDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Weather'),
            onTap: () {
              Navigator.pushNamed(context, '/weather');
            },
          ),
          ListTile(
            title: const Text('Groceries'),
            onTap: () {
              Navigator.pushNamed(context, '/groceries');
            },
          ),
        ],
      ),
    );
  }
}
