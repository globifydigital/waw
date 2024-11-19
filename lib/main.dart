
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waw/rest/hive_repo.dart';
import 'package:waw/routes/app_router.dart';
import 'package:waw/theme/themes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveRepo.initialize('waw');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {
        ScreenUtil.init(
          context,
          designSize: const Size(390, 844),
          minTextAdapt: true,
        );
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'WAW',
          theme: themeData(),
          routerConfig: _appRouter.config(),
        );
      },
    );
  }
}