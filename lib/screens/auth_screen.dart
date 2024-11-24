import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../services/http_exception.dart';

enum AuthMode {
  register,
  login,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode authMode = AuthMode.login;
  final GlobalKey<FormState> _globalKey = GlobalKey();
  final TextEditingController _passwordController = TextEditingController();
  var isLoading = false;

  void _switchAuthMode() {
    if (authMode == AuthMode.login) {
      setState(() {
        authMode = AuthMode.register;
      });
    } else {
      setState(() {
        authMode = AuthMode.login;
      });
    }
  }

  void showModel(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Xatolik!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> submit() async {
    FocusScope.of(context).unfocus();
    if (_globalKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _globalKey.currentState!.save();
      try {
        if (authMode == AuthMode.login) {
          await Provider.of<Auth>(context, listen: false).signIn(
            storageMail['gmail'],
            storageMail['password'],
          );
        } else {
          await Provider.of<Auth>(context, listen: false).signUp(
            storageMail['gmail'],
            storageMail['password'],
          );
        }
      } on HttpException catch (error) {
        var errorMessage = 'Xatolik';
        if (error.messanger.contains('EMAIL_EXISTS')) {
          errorMessage = 'Bu foydalanuvchi oldin ro\'yxatdan o\'tgan!';
        } else if (error.messanger.contains('INVALID_LOGIN')) {
          errorMessage = 'Bu foydalanuvchi topilmadi';
        } else if (error.messanger.contains('INVALID_PASSWORD')) {
          errorMessage = 'Parol noto\'g\'ri';
        }
        showModel(context, errorMessage);
      } catch (e) {
        var errorMessage = 'Xatolik sodir bo\'ldi qayta urinib ko\'ring!';
        showModel(context, errorMessage);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Map<String, dynamic> storageMail = {
    'gmail': '',
    'password': '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SHOPPING APP',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.amber,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('User name or Gmail'),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (mail) {
                          storageMail['gmail'] = mail;
                          if (mail == null || mail.isEmpty) {
                            return 'Iltimos, Gmail kiriting';
                          } else if (!mail.contains('@')) {
                            return 'Noto\'g\'ri gmail!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Password'),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        validator: (password) {
                          storageMail['password'] = password;
                          if (password == null || password.isEmpty) {
                            return 'Iltimos, parol kiriting';
                          } else if (password.length < 8) {
                            return 'Noto\'g\'ri parol!';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      if (authMode == AuthMode.register)
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Confirm Password'),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return 'Iltimos, tasdiqlash parol kiriting';
                                } else if (_passwordController.text !=
                                    password) {
                                  return 'parollar bir xil emas!';
                                }
                                return null;
                              },
                              obscureText: true,
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 40,
                      ),
                      isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.amber,
                            )
                          : ElevatedButton(
                              onPressed: submit,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                backgroundColor: Colors.amber,
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      authMode == AuthMode.login
                                          ? 'KIRISH'
                                          : 'RO\'YXATDAN O\'TISH',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                          authMode == AuthMode.register
                              ? 'KIRISH'
                              : 'RO\'YXATDAN O\'TISH',
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
