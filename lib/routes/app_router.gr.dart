// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:flutter/material.dart' as _i17;
import 'package:waw/app_informative_screen.dart' as _i2;
import 'package:waw/screens/dashboard.dart' as _i3;
import 'package:waw/screens/notifications/notifications.dart' as _i6;
import 'package:waw/screens/profile/about_us_screen.dart' as _i1;
import 'package:waw/screens/profile/privacy_policy_screen.dart' as _i8;
import 'package:waw/screens/profile/profile_editScreen.dart' as _i9;
import 'package:waw/screens/profile/profile_screen.dart' as _i10;
import 'package:waw/screens/profile/terms_and_condition_screen.dart' as _i15;
import 'package:waw/screens/registration/login_screen.dart' as _i12;
import 'package:waw/screens/registration/OTP_screen.dart' as _i7;
import 'package:waw/screens/registration/registration_screen.dart' as _i13;
import 'package:waw/screens/tabs/home_tab.dart' as _i4;
import 'package:waw/screens/tabs/menu_tabb.dart' as _i5;
import 'package:waw/screens/videos/recent_ads.dart' as _i11;
import 'package:waw/splash_screen.dart' as _i14;

abstract class $AppRouter extends _i16.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i16.PageFactory> pagesMap = {
    AboutUsRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AboutUsScreen(),
      );
    },
    AppInformationRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppInformationScreen(),
      );
    },
    DashboardRoute.name: (routeData) {
      final args = routeData.argsAs<DashboardRouteArgs>();
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.DashboardScreen(
          key: args.key,
          bottomIndex: args.bottomIndex,
        ),
      );
    },
    HomeTab.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomeTab(),
      );
    },
    MenuTab.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.MenuTab(),
      );
    },
    NotificationsRoute.name: (routeData) {
      final args = routeData.argsAs<NotificationsRouteArgs>();
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.NotificationsScreen(
          key: args.key,
          bottomIndex: args.bottomIndex,
        ),
      );
    },
    OtpRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.OtpScreen(),
      );
    },
    PrivacyPolicyRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.PrivacyPolicyScreen(),
      );
    },
    ProfileEditRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.ProfileEditScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ProfileScreen(),
      );
    },
    RecentAdsRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.RecentAdsScreen(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SignUpScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.SplashScreen(),
      );
    },
    TermsAndConditionRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.TermsAndConditionScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AboutUsScreen]
class AboutUsRoute extends _i16.PageRouteInfo<void> {
  const AboutUsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          AboutUsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutUsRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppInformationScreen]
class AppInformationRoute extends _i16.PageRouteInfo<void> {
  const AppInformationRoute({List<_i16.PageRouteInfo>? children})
      : super(
          AppInformationRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppInformationRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i3.DashboardScreen]
class DashboardRoute extends _i16.PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({
    _i17.Key? key,
    required int bottomIndex,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          DashboardRoute.name,
          args: DashboardRouteArgs(
            key: key,
            bottomIndex: bottomIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const _i16.PageInfo<DashboardRouteArgs> page =
      _i16.PageInfo<DashboardRouteArgs>(name);
}

class DashboardRouteArgs {
  const DashboardRouteArgs({
    this.key,
    required this.bottomIndex,
  });

  final _i17.Key? key;

  final int bottomIndex;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key, bottomIndex: $bottomIndex}';
  }
}

/// generated route for
/// [_i4.HomeTab]
class HomeTab extends _i16.PageRouteInfo<void> {
  const HomeTab({List<_i16.PageRouteInfo>? children})
      : super(
          HomeTab.name,
          initialChildren: children,
        );

  static const String name = 'HomeTab';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i5.MenuTab]
class MenuTab extends _i16.PageRouteInfo<void> {
  const MenuTab({List<_i16.PageRouteInfo>? children})
      : super(
          MenuTab.name,
          initialChildren: children,
        );

  static const String name = 'MenuTab';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i6.NotificationsScreen]
class NotificationsRoute extends _i16.PageRouteInfo<NotificationsRouteArgs> {
  NotificationsRoute({
    _i17.Key? key,
    required int bottomIndex,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          NotificationsRoute.name,
          args: NotificationsRouteArgs(
            key: key,
            bottomIndex: bottomIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const _i16.PageInfo<NotificationsRouteArgs> page =
      _i16.PageInfo<NotificationsRouteArgs>(name);
}

class NotificationsRouteArgs {
  const NotificationsRouteArgs({
    this.key,
    required this.bottomIndex,
  });

  final _i17.Key? key;

  final int bottomIndex;

  @override
  String toString() {
    return 'NotificationsRouteArgs{key: $key, bottomIndex: $bottomIndex}';
  }
}

/// generated route for
/// [_i7.OtpScreen]
class OtpRoute extends _i16.PageRouteInfo<void> {
  const OtpRoute({List<_i16.PageRouteInfo>? children})
      : super(
          OtpRoute.name,
          initialChildren: children,
        );

  static const String name = 'OtpRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i8.PrivacyPolicyScreen]
class PrivacyPolicyRoute extends _i16.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i16.PageRouteInfo>? children})
      : super(
          PrivacyPolicyRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicyRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ProfileEditScreen]
class ProfileEditRoute extends _i16.PageRouteInfo<void> {
  const ProfileEditRoute({List<_i16.PageRouteInfo>? children})
      : super(
          ProfileEditRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileEditRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i10.ProfileScreen]
class ProfileRoute extends _i16.PageRouteInfo<void> {
  const ProfileRoute({List<_i16.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i11.RecentAdsScreen]
class RecentAdsRoute extends _i16.PageRouteInfo<void> {
  const RecentAdsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          RecentAdsRoute.name,
          initialChildren: children,
        );

  static const String name = 'RecentAdsRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SignInScreen]
class SignInRoute extends _i16.PageRouteInfo<void> {
  const SignInRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SignUpScreen]
class SignUpRoute extends _i16.PageRouteInfo<void> {
  const SignUpRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i14.SplashScreen]
class SplashRoute extends _i16.PageRouteInfo<void> {
  const SplashRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i15.TermsAndConditionScreen]
class TermsAndConditionRoute extends _i16.PageRouteInfo<void> {
  const TermsAndConditionRoute({List<_i16.PageRouteInfo>? children})
      : super(
          TermsAndConditionRoute.name,
          initialChildren: children,
        );

  static const String name = 'TermsAndConditionRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}
