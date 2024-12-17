

import 'package:auto_route/auto_route.dart';
import 'package:waw/app_informative_screen.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: SplashRoute.page,
      initial: true,
    ),
    AutoRoute(page: AppInformationRoute.page),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: OtpRoute.page),
    AutoRoute(page: DashboardRoute.page),
    AutoRoute(page: RecentAdsRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: NotificationsRoute.page),
    AutoRoute(page: ProfileEditRoute.page),
    AutoRoute(page: AboutUsRoute.page),
    AutoRoute(page: PrivacyPolicyRoute.page),
    AutoRoute(page: TermsAndConditionRoute.page),
  ];
}