class ApiEndpoints {
  const ApiEndpoints._();

  //static const String baseUrl = 'http://192.168.1.3:8080/api';
  static const String baseUrl = 'http://localhost:8080/api';
  //static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const String login = '/auth/login';
  static const String register = '/usuarios/registro';
  static const String servicios = '/servicios';
  static const String citas = '/citas';
  static const String usuarios = '/usuarios';
}
