import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'src/app/app.dart';
import 'src/app/app_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/app/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  await dotenv.load(fileName: ".env");
  await di.init();
  AppEntity.uid = await secureStorage.read(key: "uid");
  runApp(BloodApp());
}
