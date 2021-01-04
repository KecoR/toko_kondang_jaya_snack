import 'package:flutter/material.dart';
import 'package:toko_kondang_jaya_snack/models/appConstants.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/adminNotification.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/adminPage.dart';
import 'package:toko_kondang_jaya_snack/screens/loginPage.dart';

class AdminHomePage extends StatefulWidget {
  static final String routeName = '/adminPageRoute';
  final int index;

  const AdminHomePage({Key key, this.index}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<String> _pageTitles = [
    'Home',
    'Notification',
  ];

  final List<Widget> _pages = [
    AdminPage(),
    AdminNotification(),
  ];

  BottomNavigationBarItem _buildNavigationItem(
    int index,
    IconData iconData,
    String text,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: AppConstants.noneSelectedIconColor,
      ),
      activeIcon: Icon(
        iconData,
        color: AppConstants.selectedIconColor,
      ),
      // ignore: deprecated_member_use
      title: Text(
        text,
        style: TextStyle(
          color: _selectedIndex == index
              ? AppConstants.selectedIconColor
              : AppConstants.noneSelectedIconColor,
        ),
      ),
    );
  }

  @override
  void initState() {
    this._selectedIndex = widget.index ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, LoginPage.routeName),
          )
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildNavigationItem(0, Icons.home, _pageTitles[0]),
          _buildNavigationItem(1, Icons.notifications, _pageTitles[1]),
        ],
      ),
    );
  }
}
