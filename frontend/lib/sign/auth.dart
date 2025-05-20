import 'package:flutter/material.dart';
import 'package:punctualis_1/utils/validated_text_field.dart';
import 'package:punctualis_1/api/api_service.dart';

class Authorize extends StatefulWidget {
  const Authorize({super.key});

  @override
  State<Authorize> createState() => _AutorizeState();
}

class _AutorizeState extends State<Authorize> {
  bool _hidePassword = true;
  bool _isChecked = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);

    return _emailError == null && _passwordError == null;
  }

  void _validateEmail(String? value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+$',
      caseSensitive: false,
    );
    setState(() {
      if (value == null || value.isEmpty) {
        _emailError = 'Обязательное поле';
      } else if (!emailRegex.hasMatch(value) ||
          value.length < 7 ||
          value.length > 50) {
        _emailError = 'Некорректная форма записи';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String? value) {
    final validPasswordRegex = RegExp(
      r'^[\w!@#$%^&*()\-+=[\]{};:"\\|,.<>/?]+$',
    );
    setState(() {
      if (value == null || value.isEmpty) {
        _passwordError = 'Обязательное поле';
      } else if (value.length < 6) {
        _passwordError = 'Минимум 6 символов';
      } else if (value.length > 30) {
        _passwordError = 'Максимум 30 символов';
      } else if (value.contains(' ')) {
        _passwordError = 'Не должно содержать пробелов';
      } else if (!validPasswordRegex.hasMatch(value)) {
        _passwordError = 'Недопустимые символы';
      } else {
        _passwordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text("Авторизация"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                ValidatedTextField(
                  labelText: "E-mail",
                  controller: _emailController,
                  errorText: _emailError,
                  onChanged: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 40),
                ValidatedTextField(
                  labelText: 'Пароль',
                  controller: _passwordController,
                  errorText: _passwordError,
                  onChanged: _validatePassword,
                  obscureText: _hidePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                    icon: Icon(
                      _hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),

                const SizedBox(height: 5),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    const Text("Запомнить пароль"),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 3.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: const Text("Назад"),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          if (_validateForm()) {
                            final ApiService _apiService = ApiService();
                            try {
                              await _apiService.login(
                                _emailController.text,
                                _passwordController.text,
                                _isChecked
                              );
                              Navigator.pushReplacementNamed(context, '/dlg');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                        child: const Text("Далее"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
