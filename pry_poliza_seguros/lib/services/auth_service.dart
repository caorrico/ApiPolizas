import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _keyUser = 'user_data';
  static const String _keyToken = 'auth_token';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Simulamos una API - puedes cambiar esto por tu endpoint real
  static const String _baseUrl = 'http://localhost:9090/api/auth';

  // Guardar datos del usuario
  Future<void> saveUserData(User user) async {
    await _storage.write(key: _keyUser, value: json.encode(user.toJson()));
    await _storage.write(key: _keyToken, value: user.token ?? '');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // Obtener datos del usuario
  Future<User?> getUserData() async {
    try {
      final userData = await _storage.read(key: _keyUser);
      if (userData != null) {
        return User.fromJson(json.decode(userData));
      }
    } catch (e) {
      print('Error reading user data: $e');
    }
    return null;
  }

  // Verificar si está logueado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Simulación de llamada a API - reemplaza con tu endpoint real
      /*
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User(
          email: email,
          password: password,
          token: data['token'],
        );
        await saveUserData(user);
        return {'success': true, 'message': 'Login exitoso'};
      } else {
        return {'success': false, 'message': 'Credenciales inválidas'};
      }
      */

      // Simulación para desarrollo - eliminar en producción
      await Future.delayed(Duration(seconds: 2)); // Simular latencia de red
      
      // Validación básica para demo
      if (email.isNotEmpty && password.length >= 6) {
        final user = User(
          email: email,
          password: password,
          token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
        );
        await saveUserData(user);
        return {'success': true, 'message': 'Login exitoso'};
      } else {
        return {'success': false, 'message': 'Email requerido y contraseña mínimo 6 caracteres'};
      }
      
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Registro
  Future<Map<String, dynamic>> register(String email, String password, String confirmPassword) async {
    try {
      // Validaciones
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        return {'success': false, 'message': 'Todos los campos son requeridos'};
      }

      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Email no válido'};
      }

      if (password.length < 6) {
        return {'success': false, 'message': 'La contraseña debe tener al menos 6 caracteres'};
      }

      if (password != confirmPassword) {
        return {'success': false, 'message': 'Las contraseñas no coinciden'};
      }

      // Simulación de llamada a API - reemplaza con tu endpoint real
      /*
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final user = User(
          email: email,
          password: password,
          token: data['token'],
        );
        await saveUserData(user);
        return {'success': true, 'message': 'Registro exitoso'};
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'Error en el registro'};
      }
      */

      // Simulación para desarrollo - eliminar en producción
      await Future.delayed(Duration(seconds: 2)); // Simular latencia de red
      
      // Simular verificación de email existente
      final prefs = await SharedPreferences.getInstance();
      final existingEmails = prefs.getStringList('registered_emails') ?? [];
      
      if (existingEmails.contains(email)) {
        return {'success': false, 'message': 'Este email ya está registrado'};
      }

      // "Registrar" el usuario
      existingEmails.add(email);
      await prefs.setStringList('registered_emails', existingEmails);
      
      final user = User(
        email: email,
        password: password,
        token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      await saveUserData(user);
      return {'success': true, 'message': 'Registro exitoso'};
      
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Validar formato de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Logout
  Future<void> logout() async {
    await _storage.delete(key: _keyUser);
    await _storage.delete(key: _keyToken);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // Obtener token
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }
}
