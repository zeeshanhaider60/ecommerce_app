import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthBloc({
    required AuthRepository authRepository,
    required StorageService storageService,
  }) : _authRepository = authRepository,
       _storageService = storageService,
       super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await _authRepository.login(event.username, event.password);

      final userId = _extractUserIdFromToken(token) ?? 2;
      await _storageService.saveUserId(userId);

      emit(AuthAuthenticated());
    } catch (e, stackTrace) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  int? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);

      return payloadMap['sub'] as int?;
    } catch (e) {
      return null;
    }
  }
}
