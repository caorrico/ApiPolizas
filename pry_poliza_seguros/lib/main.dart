import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/poliza_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PolizaViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestión de Pólizas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFF1565C0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Color(0xFF1565C0),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1565C0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
