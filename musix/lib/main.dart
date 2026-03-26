import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottombar.dart';
import 'package:flutter_application_1/pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/songs_provider.dart';
import 'themes/theme_provider.dart';
import 'pages/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => SongsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return auth.isAuthenticated ? const HomeScreen() : const LoginPage();
        },
      ),
      theme: Provider.of<ThemeProvider>(context).themeDate,
    );
  }
}
