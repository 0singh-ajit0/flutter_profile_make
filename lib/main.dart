import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paypie_flutter/firebase_options.dart';
import 'package:paypie_flutter/providers/profile_provider.dart';
import 'package:paypie_flutter/services/auth_service.dart';
import 'package:paypie_flutter/views/auth/login_view.dart';
import 'package:paypie_flutter/views/homescreen_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        )
      ],
      child: MaterialApp(
        title: 'PayPie Assignment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AuthService.instance.currentUser != null
            ? const HomeScreenView()
            : const LoginView(),
      ),
    );
  }
}
