import 'package:appmetrica_plugin/appmetrica_plugin.dart';

abstract class Metrica {

  static void init() {
    AppMetrica.activate(
        AppMetricaConfig("9b959d92-24b6-4267-921f-638bc1a2b6dd"));
  }

  static void test() {
    AppMetrica.reportEvent('My first AppMetrica event!');
  }

  static void loginStart() {
    AppMetrica.reportEvent('Login start');
  }

  static void loginSuccess() {
    AppMetrica.reportEvent('Login success');
  }

  static void loginFail() {
    AppMetrica.reportEvent('Login fail');
  }

  static void screenOpen(String value) {
    AppMetrica.reportEventWithMap('Screen opened', {
      'screen_name': value
    });
  }

  static void navigationMenuUsed() {
    AppMetrica.reportEvent('Navigation menu used');
  }

  static void taskCreate(String value) {
    AppMetrica.reportEventWithMap('Task created', {
      'name' : value
    });
  }

}