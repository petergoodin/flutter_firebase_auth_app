import 'package:firebase_auth_app/screens/About.dart';
import 'package:firebase_auth_app/screens/Home.dart';
import 'package:firebase_auth_app/screens/Settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveMenu with ChangeNotifier {
  String _currentMenuItem = "HomePage";

  ActiveMenu(this._currentMenuItem);
  getActiveMenu() => _currentMenuItem;
  setActiveMenu(String _menuItem) => _currentMenuItem = _menuItem;
}


class MenuDrawer extends StatelessWidget{
  final Map<String, dynamic> menus = {
    'Home': {
      'name': "HomePage",
      'labelText': "Home",
      'component': HomePage(),
      'icon': new Icon(Icons.home)
    },
    'Settings': {
      'name': "SettingsPage",
      'labelText': "Application Settings",
      'component': SettingsPage(),
      'icon': new Icon(Icons.settings)
    },
    "About": {
      'name': "AboutPage",
      'labelText': "About This App",
      'component': AboutPage(),
      'icon': new Icon(Icons.info)
    }
  };

  Future _gotoPage(Widget _page, BuildContext _context) {
    Provider.of<ActiveMenu>(_context)
        .setActiveMenu(_page.runtimeType.toString());
    Navigator.of(_context).pop();
    return Navigator.of(_context).pushReplacement(
      MaterialPageRoute(
          settings: RouteSettings(name: _page.runtimeType.toString()),
          builder: (BuildContext context) => _page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header '),
            decoration: BoxDecoration(
              color: Colors.teal.shade300,
            ),
          ),
          ...getMenuItems(context),
        ],
      ),
    );
  }

  List<Widget> getMenuItems(_context) {
    List<Widget> items = [];
    menus.forEach((String _key, dynamic _value) {
      var item = buildMenuEntryContainer(_context, _key);
      items.add(item);
    });
    return items;
  }

  Container buildMenuEntryContainer(BuildContext context, String menuName) {
    // get the require values
    var menu = menus[menuName];

    // determine if this menu item is selected/active
    var isSelected =
        Provider.of<ActiveMenu>(context).getActiveMenu() == menu['name'];

    // set properties based on application state
    var _textStyle =
        TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal);
    var _boxDecoration = isSelected
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.teal.shade100,
          )
        : BoxDecoration();

    // create the menu item widget
    return Container(
      margin: EdgeInsets.only(left: 6.0, right: 6.0),
      decoration: _boxDecoration,
      child: ListTile(
        leading: menu['icon'],
        selected: isSelected,
        title: Text(
          menu['labelText'],
          style: _textStyle,
        ),
        onTap: () {
          _gotoPage(menu['component'], context);
        },
      ),
    );
  }
}
