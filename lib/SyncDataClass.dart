import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:empire_ios/SyncData.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

import 'dart:math' as math;

import 'package:encrypt/encrypt.dart' as enc;

class SyncDataClass {
  static Future<List<int>?> decryptData(Uint8List? encryptedData) async {
    try {
      var mainKey =
          "${GLB_CURRENT_USER["CLIENTNO"]}${GLB_CURRENT_USER["api"]}${GLB_CURRENT_USER["Ltoken"]}${GLB_CURRENT_USER["encdb"]}${GLB_CURRENT_USER["CLIENTNO"]}";

      var keyString = "key_$mainKey";
      var ivString = "iv_$mainKey";
      Uint8List keyData = await Uint8List.fromList(utf8.encode(keyString.substring(0, math.min(16, keyString.length))));
      Uint8List ivData = await Uint8List.fromList(utf8.encode(ivString.substring(0, math.min(16, ivString.length))));

      final key = enc.Key(keyData);
      final iv = enc.IV(ivData);

      final encrypter = await enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: "PKCS7"));
      List<int>? decryptedData = await encrypter.decryptBytes(enc.Encrypted(encryptedData!), iv: iv);
      encryptedData = null;
      // Write the decrypted data to the output file

      return decryptedData;
    } catch (e) {
      backgroundSyncInProcess = false;
      return null;
    }
  }

  static Future<Uint8List?> saveUnZipFileWithoutPasswordInBytes(Uint8List? bytes) async {
    try {
      if (bytes == null) return null;

      // Step 1: Decode the archive with the provided password
      var bearer = firebaseCurrntSupUserObj["bearer"] ?? "";
      var FILE_NAME = firebaseCurrntSupUserObj["FILE_NAME"] ?? "";
      var CLNT = firebaseCurrntSupUserObj["CLNT"] ?? "";
      var passbearer = "${bearer}${FILE_NAME}${CLNT}";
      var pass = Myf.encryptAesString(passbearer);
      Archive archive = ZipDecoder().decodeBytes(bytes, password: pass);

      // Clear bytes to free up memory
      bytes = null;

      final outputArchive = Archive();

      // Step 2: Extract files without converting between data types unnecessarily
      for (final file in archive) {
        if (file.isFile) {
          try {
            final fileData = file.content as Uint8List; // Use Uint8List directly
            archive.addFile(ArchiveFile(file.name, fileData.length, fileData));
          } catch (e) {
            print("${e}${file.name}");
          }
        }
      }

      // Step 3: Encode the new archive without a password
      final newZipEncoder = ZipEncoder();
      final newZipBytes = newZipEncoder.encode(archive);

      // Step 4: Return the new ZIP file as Uint8List
      return newZipBytes != null ? Uint8List.fromList(newZipBytes) : null;
    } catch (e) {
      print('Failed to process ZIP file: $e');
      return null;
    }
  }
}
