import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  runApp(
    RepositoryProvider.value(
      value: storageService,
      child: BlocProvider(
        create: (context) => ThemeCubit(storageService),
        child: const MyApp(),
      ),
    ),
  );
}
