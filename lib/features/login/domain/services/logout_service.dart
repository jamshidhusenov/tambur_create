import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LogoutService {
  Future<bool> logout() async {
   try {
    const storage = FlutterSecureStorage();
    // Clear tokens
    await storage.delete(key: "accessToken");
    await storage.delete(key: "refreshToken");
    
    // Clear login status
    final login = Hive.box('login');
    await login.delete('logged');
    return true;
   } catch (e) {
    return false;
   }  
  } 
}
