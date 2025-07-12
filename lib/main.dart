import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'models/flashcard.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(FlashcardAdapter());

  // Initialize Mobile Ads
  MobileAds.instance.initialize();

  runApp(const YaadCardsApp());
}

class YaadCardsApp extends StatelessWidget {
  const YaadCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StorageService(),
      child: MaterialApp(
        title: 'YaadCards',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
