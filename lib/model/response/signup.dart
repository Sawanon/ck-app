import 'package:appwrite/models.dart';

class ResponseSignup {
  User user;
  String secret;

  ResponseSignup({
    required this.user,
    required this.secret,
  });

  @override
  String toString() {
    return '${{
      "userId": user.$id,
      "secret": secret,
    }}';
  }
}
