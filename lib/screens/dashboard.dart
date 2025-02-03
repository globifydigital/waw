import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waw/screens/tabs/draw_tab.dart';
import 'package:waw/screens/tabs/home_tab.dart';
import 'package:waw/screens/tabs/menu_tabb.dart';
import 'package:waw/screens/tabs/tickets_tab.dart';
import 'package:waw/theme/colors.dart';

import '../widgets/profile_shimmer_view.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  final int bottomIndex;
  const DashboardScreen({super.key, required this.bottomIndex});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState(this.bottomIndex);
}

class _DashboardScreenState extends State<DashboardScreen> {
  int bottomIndex;
  // int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    TicketsTab(),
    DrawTab(),
    MenuTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      bottomIndex = index;
    });
  }
  _DashboardScreenState(this.bottomIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(bottomIndex),
      bottomNavigationBar: CurvedNavigationBar(
        index: bottomIndex,
        items: <Widget>[
          _buildNavItem(
            icon: Icons.home,
            label: 'Home',
            isSelected: bottomIndex == 0,
          ),
          _buildNavItem(
            icon: Icons.confirmation_number,
            label: 'Tickets',
            isSelected: bottomIndex == 1,
          ),
          _buildDrawNavItem(
            isSelected: bottomIndex == 2,
          ),
          _buildProfileNavItem(
            isSelected: bottomIndex == 3,
          )
        ],
        onTap: _onItemTapped,
        backgroundColor: screenBackgroundColor,
        animationDuration: Duration(milliseconds: 300),
        color: Colors.amber[500]!,
        buttonBackgroundColor: Colors.amber,
        height: MediaQuery.of(context).size.height * 0.07,
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? screenBackgroundColor : Colors.grey[850],
            size: 28,
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: isSelected ? screenBackgroundColor : Colors.grey[850],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawNavItem({required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(5),
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.04,
            backgroundImage: AssetImage("assets/images/thedrawicon.png",),
            backgroundColor: Colors.transparent,
          ),
          Text(
            'Draw',
            style: GoogleFonts.poppins(
              color: isSelected ? screenBackgroundColor : Colors.grey[850],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileNavItem({required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(5),
          Icon(Icons.space_dashboard,),
          Text(
            'Menu',
            style: GoogleFonts.poppins(
              color: isSelected ? screenBackgroundColor : Colors.grey[850],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}
