import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recycling_app/models/response/auth/auth_model.dart';
import 'package:recycling_app/views/common/exports.dart';
import 'package:recycling_app/views/routes/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(46.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 160,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset("assets/images/logo_huanuco.png"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Iniciar Sesión",
                            textAlign: TextAlign.center,
                            style: appStyle(
                                20, Color(kDark.value), FontWeight.bold)),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() {
                                _isLoading = true;
                              });
                              final errorMessage = await Provider.of<AuthModel>(
                                      context,
                                      listen: false)
                                  .login(
                                _emailController.text,
                                _passwordController.text,
                              );
                              setState(() {
                                _isLoading = false;
                              });
                              if (errorMessage == null) {
                                Navigator.of(context).pushReplacementNamed(
                                    Routes.mainScreenRoute);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text(errorMessage),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Ingresar'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Si aún no se ha registrado, regístrese ',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              TextSpan(
                                text: 'aquí',
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 14),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.offNamed(Routes.registerRoute);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
