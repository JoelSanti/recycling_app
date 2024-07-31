import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recycling_app/constants/app_constants.dart';
import 'package:recycling_app/views/routes/routes.dart';

class AuthModel extends ChangeNotifier {
  String? _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;
  String? _token;
  String? _routeName;
  bool _isAuthenticated = false;
  String? _role; // Nueva variable para almacenar el rol del usuario

  String? get role => _role; // Getter para el rol del usuario

  String? get userId => _userId;
  String? get routeName => _routeName;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get password => _password;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  Future<String?> login(String email, String password) async {
    final urlServidor = API_URL + '/users/login';
    try {
      final response = await http.post(
        Uri.parse(urlServidor),
        body: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        _token = responseBody['token'];
        _userId = responseBody['user']['id'];
        _role = responseBody['user']['role'];
        print('Token: $_token');
        _isAuthenticated = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        notifyListeners();
        return null; // Devuelve null si el inicio de sesión es exitoso
      } else {
        // Devuelve un mensaje de error si el inicio de sesión falla
        return 'Correo electrónico o contraseña incorrectos';
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      return 'Error al realizar la solicitud: $e';
    }
  }

  Future<String> register(
      String firstName,
      String lastName,
      String email,
      String password,
      ) async {
    try {
      final urlServidor = API_URL + '/users';
      final response = await http.post(
        Uri.parse(urlServidor),
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'role': 'resident', // Or 'admin', depending on the user
        },
      );
      print(' Status  --------------------------------------- ${response.statusCode}');
      if (response.statusCode == 201) {
        _firstName = firstName;
        _lastName = lastName;
        _email = email;
        _password = password;
        _routeName = Routes.loginRoute;
        _isAuthenticated = true;
        notifyListeners();
        return 'Usuario registrado con éxito';
      } else if (response.statusCode == 400) {
        return 'El usuario ya existe';
      } else {
        return 'Fallo al registrar el usuario';
      }
    } catch (e) {
      print('Error: $e');
      return 'Error: $e';
    }
  }

  void logout() {
    // Si el servidor responde con éxito, borrar los datos locales
    _firstName = null;
    _lastName = null;
    _email = null;
    _password = null;
    _token = null;
    _routeName = null;
    _isAuthenticated = false;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
    });
    notifyListeners();
  }

  Future<void> checkAuthenticationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    final urlServidor = API_URL + '/users/me';
    if (token != null) {
      // Verificar si el token es válido en el servidor
      final response = await http.get(
        Uri.parse(urlServidor),
        headers: {'Authorization': 'JWT $token'},
      );
      if (response.statusCode == 200) {
        // Si el servidor devuelve una respuesta OK, el token es válido
        _isAuthenticated = true;
        _token = token;
        final responseBody = jsonDecode(response.body);
        _userId = responseBody['user']['id'];
        _role = responseBody['user']['role'];

      } else {
        // Si el servidor devuelve una respuesta de error, el token no es válido
        _isAuthenticated = false;
        _token = null;
        prefs.remove('token');
      }
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }
}
