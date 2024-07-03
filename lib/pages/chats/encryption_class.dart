import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  final encrypt.Key key;
  final encrypt.Encrypter encrypter;

  static const String keyString = '01234567890123456789012345678901';

  EncryptionHelper()
      : key = encrypt.Key.fromUtf8(keyString),
        encrypter = encrypt.Encrypter(encrypt.AES(
          encrypt.Key.fromUtf8(keyString),
          mode: encrypt.AESMode.cbc,
          padding: 'PKCS7',
        ));

  String encryptText(String plainText) {
    print("Encrypting text: $plainText");
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final encryptedWithIv = iv.base64 + ":" + encrypted.base64;
    print("Encrypted text: $encryptedWithIv");
    return encryptedWithIv;
  }

  String decryptText(String encryptedText) {
    print("Decrypting text: $encryptedText");
    try {
      final parts = encryptedText.split(':');
      if (parts.length != 2) {
        throw FormatException("Invalid encrypted text format");
      }
      final iv = encrypt.IV.fromBase64(parts[0]);
      final encryptedData = parts[1];
      final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
      return decrypted;
    } catch (e) {
      print("Error during decryption: $e");
      return "Decryption failed";
    }
  }

  String encryptBytes(Uint8List bytes) {
    print("Encrypting bytes of length: ${bytes.length}");
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypted = encrypter.encryptBytes(bytes, iv: iv);
    final encryptedWithIv = iv.base64 + ":" + encrypted.base64;
    print("Encrypted bytes: $encryptedWithIv");
    return encryptedWithIv;
  }

  Uint8List decryptBytes(String encryptedBytes) {
    print("Decrypting bytes: $encryptedBytes");
    try {
      final parts = encryptedBytes.split(':');
      if (parts.length != 2) {
        throw FormatException("Invalid encrypted bytes format");
      }
      final iv = encrypt.IV.fromBase64(parts[0]);
      final encryptedData = parts[1];
      final decrypted = encrypter.decryptBytes(encrypt.Encrypted.fromBase64(encryptedData), iv: iv);
      return Uint8List.fromList(decrypted);
    } catch (e) {
      print("Error during decryption: $e");
      return Uint8List(0);
    }
  }
}
