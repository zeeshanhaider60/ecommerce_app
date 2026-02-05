import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/storage_service.dart';

class ThemeState {
  final bool isDarkMode;

  const ThemeState({required this.isDarkMode});
}

class ThemeCubit extends Cubit<ThemeState> {
  final StorageService _storageService;

  ThemeCubit(this._storageService)
    : super(ThemeState(isDarkMode: _storageService.isDarkMode()));

  void toggleTheme() {
    final newMode = !state.isDarkMode;
    _storageService.setDarkMode(newMode);
    emit(ThemeState(isDarkMode: newMode));
  }
}
