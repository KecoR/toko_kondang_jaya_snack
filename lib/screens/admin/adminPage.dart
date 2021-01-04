import 'package:flutter/material.dart';

import 'package:toko_kondang_jaya_snack/widgets/customRaisedButton.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/adminViewStock.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/adminMonitoring.dart';
import 'package:toko_kondang_jaya_snack/screens/admin/adminViewMember.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  void _goToPage(BuildContext context, goToPage) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => goToPage,
      ),
    );
  }

  void _viewStock(BuildContext context) {
    _goToPage(context, AdminViewStock());
  }

  void _monitoringView(BuildContext context) {
    _goToPage(context, AdminMonitoring());
  }

  void _viewMember(BuildContext context) {
    _goToPage(context, AdminViewMember());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomRaisedButton(
            child: Text('Monitoring View'),
            borderRadius: 50.0,
            onPressed: () => _monitoringView(context),
          ),
          SizedBox(height: 30.0),
          CustomRaisedButton(
            child: Text('View Member'),
            borderRadius: 50.0,
            onPressed: () => _viewMember(context),
          ),
          SizedBox(height: 30.0),
          CustomRaisedButton(
            child: Text('View Stock'),
            borderRadius: 50.0,
            onPressed: () => _viewStock(context),
          ),
        ],
      ),
    );
  }
}
