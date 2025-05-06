import 'package:flutter/material.dart';
import 'package:punctualis_1/utils/validated_text_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  String? _nameError;
  String? _surnameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
  
    _validateName(_nameController.text);
    _validateSurname(_surnameController.text);
    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);
    _validateConfirmPassword(_confirmPasswordController.text);


    return _nameError == null &&
        _surnameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  void _validateName(String? value) {
    final validCharacters = RegExp(r'^[a-zA-Zа-яА-ЯёЁ\-]+$');
    setState(() {
      if (value == null || value.isEmpty) {
        _nameError = 'Обязательное поле';
      } else if (value.length > 20 || !validCharacters.hasMatch(value)) {
        _nameError = 'Некорректная форма записи';
      } else {
        _nameError = null;
      }
    });
  }

  void _validateSurname(String? value) {
    final validCharacters = RegExp(r'^[a-zA-Zа-яА-ЯёЁ\-]+$');
    setState(() {
      if (value == null || value.isEmpty) {
        _surnameError = 'Обязательное поле';
      } else if (value.length > 50 || !validCharacters.hasMatch(value)) {
        _surnameError = 'Некорректная форма записи';
      } else {
        _surnameError = null;
      }
    });
  }

  void _validateEmail(String? value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+$',
      caseSensitive: false,
    );
    setState(() {
      if (value == null || value.isEmpty) {
        _emailError = 'Обязательное поле';
      } else if (!emailRegex.hasMatch(value) || value.length < 7 || value.length > 50) {
        _emailError = 'Некорректная форма записи';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String? value) {
    final validPasswordRegex = RegExp(r'^[\w!@#$%^&*()\-+=[\]{};:"\\|,.<>/?]+$');
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

  void _validateConfirmPassword(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        _confirmPasswordError = 'Обязательное поле';
      } else if (value != _passwordController.text) {
        _confirmPasswordError = 'Пароли должны совпадать';
      } else {
        _confirmPasswordError = null;
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
        title: const Text("Регистрация"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ValidatedTextField(
                  labelText: 'Имя',
                  controller: _nameController,
                  errorText: _nameError,
                  onChanged: _validateName,
                ),
                ValidatedTextField(
                  labelText: 'Фамилия',
                  controller: _surnameController,
                  errorText: _surnameError,
                  onChanged: _validateSurname,
                ),
                ValidatedTextField(
                  labelText: "E-mail",
                  controller: _emailController,
                  errorText: _emailError,
                  onChanged: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
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
                ValidatedTextField(
                  labelText: 'Подтвердите пароль',
                  controller: _confirmPasswordController,
                  errorText: _confirmPasswordError,
                  onChanged: _validateConfirmPassword,
                  obscureText: _hideConfirmPassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hideConfirmPassword = !_hideConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 3.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: const Text("Назад"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (_validateForm()) {
                            Navigator.pushNamed(context, '/conf');
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