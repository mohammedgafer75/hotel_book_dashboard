import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';
import 'package:hotel_book_dashboard/screens/change_password.dart';
import 'package:hotel_book_dashboard/screens/customer_page.dart';
import 'package:hotel_book_dashboard/screens/room_management.dart';
import 'package:hotel_book_dashboard/screens/services_screen.dart';

import '../controller/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _selectedScreen = const RoomManagement();
  final AuthController controller = Get.put(AuthController());

  currentScreen(item) {
    switch (item.route) {
      case RoomManagement.id:
        setState(() {
          _selectedScreen = const RoomManagement();
        });
        break;
      case CustomerPage.id:
        setState(() {
          _selectedScreen = const CustomerPage();
        });
        break;
      case ServicesPage.id:
        setState(() {
          _selectedScreen = const ServicesPage();
        });
        break;
      case ChangePassword.id:
        setState(() {
          _selectedScreen = const ChangePassword();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        title: const Text('Admin Panel'),
      ),
      sideBar: SideBar(
        textStyle: const TextStyle(color: Colors.white),
        activeTextStyle: const TextStyle(color: Colors.white),
        iconColor: Colors.amber.shade700,
        activeIconColor: Colors.amber.shade700,
        backgroundColor: Colors.black12,
        activeBackgroundColor: Colors.black12,
        items: const [
          MenuItem(
            title: 'Room Management Page',
            route: RoomManagement.id,
            icon: Icons.room,
          ),
          MenuItem(
            title: 'Customers Page ',
            route: CustomerPage.id,
            icon: Icons.person,
          ),
          MenuItem(
            title: 'Services Page',
            route: ServicesPage.id,
            icon: Icons.design_services,
          ),
          MenuItem(
            title: 'Change Password',
            route: ChangePassword.id,
            icon: Icons.lock,
          ),
        ],
        footer: GestureDetector(
          onTap: () {
            controller.signOut();
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            color: Colors.amber.shade700,
            child: Row(
              children: const [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text('LogOut'),
              ],
            ),
          ),
        ),
        selectedRoute: RoomManagement.id,
        onSelected: (item) {
          currentScreen(item);
          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
          // }
        },
        // footer: Container(
        //   height: 50,
        //   width: double.infinity,
        //   color: const Color(0xff444444),
        //   child: const Center(
        //     child: Text(
        //       'footer',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(child: _selectedScreen),
    );
  }
}
