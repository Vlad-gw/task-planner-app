import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({super.key});

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text("Подтвердите, что это вы"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "На Вашу почту отправлен шестизначный код подтверждения, пожалуйста, введите его для подтверждения аккаунта",
                  ),
                ),

                SizedBox(height: 40),
                PinCodeTextField(
                  appContext: context,
                  controller: controller,
                  length: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  enableActiveFill: true,
                  cursorColor: Colors.black,
                  animationType: AnimationType.scale,
                  cursorHeight: 27,
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeColor: Color.fromARGB(
                      255,
                      230,
                      224,
                      233,
                    ), // Бежевый для активного поля
                    inactiveColor: Color.fromARGB(
                      255,
                      230,
                      224,
                      233,
                    ), // Бежевый для неактивного
                    selectedColor: Color.fromARGB(
                      255,
                      230,
                      224,
                      233,
                    ), // Темно-бежевый при выборе
                    activeFillColor: Color.fromARGB(255, 230, 224, 233),
                    inactiveFillColor: Color.fromARGB(255, 230, 224, 233),
                    selectedFillColor: Color.fromARGB(255, 230, 224, 233),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Отправить код ещё раз",
                    style: TextStyle(color: Color.fromARGB(255, 208, 188, 255)),
                  ),
                ),
                SizedBox(height: 20),
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
                        onPressed: () {},
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
