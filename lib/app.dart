import 'package:ecommerce_app/presentation/blocs/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'data/repositories/auth_repository.dart';
import 'services/storage_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = context.read<StorageService>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return RepositoryProvider(
              create:
                  (context) => AuthRepository(storageService: storageService),
              child: BlocProvider(
                create:
                    (context) => AuthBloc(
                      authRepository: context.read<AuthRepository>(),
                      storageService: storageService,
                    )..add(AppStarted()),
                child: MaterialApp(
                  title: 'E-Commerce App',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode:
                      themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
