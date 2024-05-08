import 'package:atma_kitchen/screens/customer/home.dart';
import 'package:atma_kitchen/screens/customer/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomerTabsScreen extends StatefulWidget {
  const CustomerTabsScreen({super.key});

  @override
  State<CustomerTabsScreen> createState() => _CustomerTabsScreenState();
}

class _CustomerTabsScreenState extends State<CustomerTabsScreen> {
  int _selectedPageIndex = 0;
  int? idUser;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void getIdUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUser = pref.getInt('id')!;
    });
  }

  @override
  void initState() {
    super.initState();
    getIdUser();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      Device.orientation == Orientation.portrait
          ? Container(
              width: 100.w,
              height: 20.5.h,
            )
          : Container(
              width: 100.w,
              height: 12.5.h,
            );

      Device.screenType == ScreenType.tablet
          ? Container(
              width: 100.w,
              height: 20.5.h,
            )
          : Container(
              width: 100.w,
              height: 12.5.h,
            );

      Widget activePage = const CustomerHome();

      if (_selectedPageIndex == 0) {
        activePage = const CustomerHome();
      } else if (_selectedPageIndex == 1) {
        activePage = const CustomerHome();
      } else if (_selectedPageIndex == 2) {
        activePage = const CustomerProfile();
      }

      return Scaffold(
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPageIndex,
          onTap: _selectPage,
          fixedColor: const Color.fromARGB(255, 43, 57, 164),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              label: 'Pemesanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_add_outlined),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
