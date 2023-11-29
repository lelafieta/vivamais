// import 'package:encrypt/encrypt.dart' as encrypt;

// class MyEncryptionDecription {
//   static final key = encrypt.Key.fromLength(32);
//   static final iv = encrypt.IV.fromLength(16);
//   static final encrypter = encrypt.Encrypter(encrypt.AES(key));

//   static encryptAES(text) {
//     final encrypted = encrypter.encrypt(text, iv: iv);

//     // print(encrypted.bytes);
//     // print(encrypted.base16);
//     // print(encrypted.base64);
//     return encrypted;
//   }

//   static decryptAES(text) {
//     return encrypter.decrypt(text, iv: iv);
//   }
// }

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryptionDecription {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static final secureStorage = FlutterSecureStorage();

  static Future<void> storeEncryptedData(String key, String data) async {
    final encryptedData = encryptAES(data);
    await secureStorage.write(key: key, value: encryptedData.base64);
  }

  static Future<String?> retrieveDecryptedData(String key) async {
    final encryptedData = await secureStorage.read(key: key);
    if (encryptedData != null) {
      final decryptedData =
          decryptAES(encrypt.Encrypted.fromBase64(encryptedData));
      return decryptedData;
    }
    return null;
  }

  static encryptAES(String text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted;
  }

  static String decryptAES(encrypt.Encrypted encrypted) {
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
