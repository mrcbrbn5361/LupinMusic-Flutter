import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/lupin_theme.dart';
import 'providers/player_provider.dart';
import 'views/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: const LupinApp(),
    ),
  );
}

class LupinApp extends StatelessWidget {
  const LupinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lupin Music',
      debugShowCheckedModeBanner: false,
      theme: LupinTheme.darkTheme,
      home: const MainLayout(),
    );
  }
}
