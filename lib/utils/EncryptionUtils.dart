import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

const clientPrivateKey =
    "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAyoQCqv0+VpyrJNgxv9SaUkWPp5KedA0qiBY3h2HWLCxYfdhR\nJZ56h5hmOc3Y8A72RlEkXGR4uFnIHt8oq0MCRyW0/7YYY5mReV39VY2BWvpvgbb4\naHfY5uHrABrZ7uTBzuPtrKKNhw9y2XtvDudwFPbVg3Kr48IWfNDbhHn4pGmM1PxH\n7wmYh1g3pFpwdT34Pge3gVWBR3miwHcqah4zfP0Ipwh23iU0GBZjT6iS1oVoUyeR\n1ftb6WvLlXVBC2f5N+04n4XDgamtcZTLB1NrAnMRZF5nWTpSsYqjUW3MjTuKzgtd\n1SVvCcLDXNU+KILU4itui5OcV+dW4yn4Rt9xLwIDAQABAoIBAECjfg6BokIW43Fx\nJ//ophEYbs+3tqeoBClHnhWyHqAez2frgYsWWFmrRQWyNEn7HJQ5Fff/gaCl14Az\nDlILo1B+MpVj08kGnS4118RU1DLruGeYtRTzG+IlvdJcv67GiS22BoiRoca4IZpV\nEY+aQ2YNmvzHvyGFM5RHPam9HKWtEYnJQeJzm6taCbabNtynvu2J9C2y8OldT8x2\nlzlOjybjRc6QJY9tQLLStW4ZP30UbyvqV5KYiMR3YX+6KsobpSAdcXc/2ijjhYj5\nFuSLUAEbSetTuEmSL4N9o1vxeO8cee18YW0yrEGUtp8tFHu2MwDb1zbZB0XEIr2C\nKnpQScECgYEA6Kma1XpzR2q82MtqzfopyyEFJ4qCZwopK9wOGPDDH7HdZGoaYnKB\njV/nFVbE3XxXZyoLQEllOQG4qx2EO84JxVmfhdRtsDIoR7L59ScfXA9bGW4ravDU\nrUx+qtucYSu14W0J8GS54zDMG2vqDPX6oZrtJFrnhQ/BWblVudZ2Yd8CgYEA3tRI\njvlg6Fcoib8zLAQXSjM/lfcUhVIRU0HVIs3/jdDSSYeuj8mR+kgKZBCMzByGNwEy\nAtI4i8ASBdMSWeaRox38Bn6c/X4vpAG8fgi1oWM0bBhltL/MBKMIHgltAYmMZ4mb\nvadkpoxdVSNq3ax9fszG5HUOgnRvBUtAv57O+rECgYBwkBXr8IkzZS2miYvLyZtM\nvlX7EmUSqvTOVnGvmVQd0nS1LyxCsvmAx4RKa6dlLNIwhEPbP2cslGuexfIC6SUL\nCNhH7EWBOFMKlUmfVOU0Ke2+OPHilE+g5GBoE0XuMTKWtKVZW7Ife61UGvqqeJtg\nck8HBr/6PWwjF6qk9WBi6wKBgQCHdwLNeKoDVcldRJG1dp86CsHjR5yAGI5T0Tfj\nutxbuNG+xe/HlkFaqKU4hB80jzrBAccHlAmwXAoY5GLJqLRtN/NZd2u1aBtKV4vi\nCyVwgcEC3iomoltDjmGG8TAFuTtUToIR4Ev+PGMZOTjkntKEXbWkec1iXaqIy2EH\nnWIzYQKBgAEkANLjCRJa6ANsujZM+nddl8fPUWzi0cSvzJxNeM0J2H/Y6fst27lq\n59bgST9FWSBK8DrgF0JkK4dWFR3OXLUp2wnehejXijdOYiosf79htF+v/mwZvS5Y\npIl76LO3YTiggA48Ukym7TIsVfIYNlih0sZz9uMG96spZsFLsON4\n-----END RSA PRIVATE KEY-----";

const serverPublicKey = "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzAtfSxfxZkT12TsoAYay\nmrS3a9hz5FT+daLAyVqR5p0VrSAkMgcgLBkOMynHA5GeMHNthhW8V/GKuXLetwj7\n1U2jNDK2LmMKzkc5NRyM2W4E/PUTrog9ztuHdhitLDVrlRyDZYLNZr6EXRYpZr++\nbTU1Ylh6Wa/ppO/wvspWBKEg+Z9CUWJLqvqlBErwd67aXUO2ZgrZj8E+sIf4v3q8\n4T0BrrPliIwTbo5jAVZIdaMo0MkJLbH62hv2w78Q3mPOjGGrmO05bd7VwNFBxqSL\nj1KTTidTceCv8pKKIwUtIkuHOE0sIGReyai3704Iow5AEbtkXdc87bnefqZZGrbI\nWQIDAQAB\n-----END PUBLIC KEY-----";

var pbkey = serverPublicKey;

var prikey = clientPrivateKey;

class RsaEncrypt {
  ///  加密
  static encryption(String content) {
    final parser = RSAKeyParser();
    String publicKeyString = pbkey;
    // print('publicKeyString=$publicKeyString'); // 注意这一行的输出
    RSAPublicKey publicKey = parser.parse(publicKeyString) as RSAPublicKey;
    final encrypter = Encrypter(RSA(
        publicKey: publicKey,
        encoding: RSAEncoding.OAEP,
        digest: RSADigest.SHA256));
    return encrypter.encrypt(content).base64;
  }

  /// 解密
  static String decrypt(String decoded) {
    final parser = RSAKeyParser();
    String privateKeyString = prikey;
    final privateKey = parser.parse(privateKeyString) as RSAPrivateKey;
    final encrypter = Encrypter(RSA(
        privateKey: privateKey,
        encoding: RSAEncoding.OAEP,
        digest: RSADigest.SHA256));
    return encrypter.decrypt(Encrypted.fromBase64(decoded));
  }

  // 签名数据
  static String sign(String message) {
    final parser = RSAKeyParser();
    String privateKeyString = prikey;
    final privateKey = parser.parse(privateKeyString) as RSAPrivateKey;
    final signer =
        Signer(RSASigner(RSASignDigest.SHA256, privateKey: privateKey));
    final sig = signer.signBytes(utf8.encode(message));
    return sig.base64;
  }

// 验证签名
  static bool verify(String message, String signature) {
    final parser = RSAKeyParser();
    String publicKeyString = pbkey;
    RSAPublicKey publicKey = parser.parse(publicKeyString) as RSAPublicKey;
    final verifier =
        Signer(RSASigner(RSASignDigest.SHA256, publicKey: publicKey));
    return verifier.verifyBytes(
        utf8.encode(message), Encrypted.fromBase64(signature));
  }
}

class AESHelper {
  static String encryptText(String text, String keyString, String ivString) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromUtf8(ivString);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static String decryptText(
      String base64Text, String keyString, String ivString) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromUtf8(ivString);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final decrypted = encrypter.decrypt64(base64Text, iv: iv);
    return decrypted;
  }

  static String createAESKey(int length) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  static String generateRandomIV() {
    return createAESKey(16); // IV 的标准长度是 16 字节
  }

  static String generateRandomKey() {
    return createAESKey(32); // IV 的标准长度是 16 字节
  }
}

class ParamsTools {
  static Map<String, dynamic> encodeAesRsaParams(String content) {
    var aesKey = AESHelper.generateRandomKey();
    var aesIv = AESHelper.generateRandomIV();
    var encodeParamsValue = AESHelper.encryptText(content, aesKey, aesIv);
    var encodeAesKeyIv = RsaEncrypt.encryption("$aesKey,$aesIv");
    var sign = RsaEncrypt.sign(content);
    Map<String, String> map = {};
    map['c'] = encodeParamsValue;
    map['t'] = encodeAesKeyIv;
    map['n'] = sign;
    return map;
  }

  static String? decodeAesRsaParams(Map<String, dynamic> map) {
    var encodeParams = map['c'];
    var encodeKeyIv = map['t'];
    var sign = map['n'];
    // val keyIv = RSATools.decodeRSA(encodeKeyIv, privateRsa).split(",")
    var keyIv = RsaEncrypt.decrypt(encodeKeyIv!).split(",");
    var key = keyIv[0];
    var iv = keyIv[1];
    var result = AESHelper.decryptText(encodeParams!, key, iv);
    var verify = RsaEncrypt.verify(result, sign!);
    if (!verify) {
      return null;
    }
    return result;
  }
}
