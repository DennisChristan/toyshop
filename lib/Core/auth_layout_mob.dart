import 'package:flutter/material.dart';
import 'package:toyshop/Core/app_loading_page.dart';
import 'package:toyshop/Core/auth_service.dart';
import 'package:toyshop/MobileApp/menu_mob.dart';
import 'package:toyshop/MobileApp/login_mob.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = AppLoadingPage();
            } else if (snapshot.hasData) {
              final uid = snapshot.data!.uid;
              widget = MenuMob(uid : uid);
            } else {
              widget = pageIfNotConnected ?? const LoginMob();
            }
            return widget;
          },
        );
      },
    );
  }
}
