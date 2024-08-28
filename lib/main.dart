import 'package:flutter/material.dart';
import 'package:full_whatsapp_monitor/notification_list_screen.dart';
import 'package:full_whatsapp_monitor/terms_and_permission_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(WhatsappMonitor());
}

class WhatsappMonitor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Whatsapp monitor",
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.data == true) {
            return NotificationListScreen();
          } else {
            return TermsAndPermissionScreen();
          }
        },
      ),
    );
  }

  Future<bool> _checkPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification_permission') ?? false;
  }
}
