import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/pro_theme_v2.dart';
import 'data/models/models.dart';
import 'screens/splash/splash_screen_v2.dart';
import 'screens/onboarding/onboarding_screen_v2.dart';
import 'screens/navigation/main_navigation_v2.dart';
import 'screens/profile/profile_screen_v2.dart';
import 'screens/hire/hire_screen_v2.dart';
import 'screens/create/create_profile_v2.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/profile/complete_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final initFuture = _initializeFirebase();
  runApp(
    ProviderScope(
      child: ProjectMadApp(firebaseInit: initFuture),
    ),
  );
}

Future<FirebaseApp> _initializeFirebase() async {
  if (kIsWeb) {
    return Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '',
      ),
    );
  }

  return Firebase.initializeApp();
}

class ProjectMadApp extends StatelessWidget {
  final Future<FirebaseApp> firebaseInit;

  const ProjectMadApp({super.key, required this.firebaseInit});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: firebaseInit,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ProTheme.lightTheme,
            darkTheme: ProTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: _FirebaseErrorScreen(error: snapshot.error),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ProTheme.lightTheme,
            darkTheme: ProTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: const _FirebaseLoadingScreen(),
          );
        }

        return MaterialApp(
          title: 'ProjectMad',
          debugShowCheckedModeBanner: false,
          theme: ProTheme.lightTheme,
          darkTheme: ProTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: const SplashScreenV2(),
          routes: {
            '/auth': (_) => const AuthScreen(),
            '/onboarding': (_) => const OnboardingScreenV2(),
            '/home': (_) => const MainNavigation(),
            '/create-profile': (_) => const CreateProfileScreen(),
            '/complete-profile': (_) => const CompleteProfileScreen(),
          },
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => _buildScreen(settings),
            );
          },
        );
      },
    );
  }

  Widget _buildScreen(RouteSettings settings) {
    switch (settings.name) {
      case '/profile':
        final args = settings.arguments;
        if (args is Professional) {
          return ProfileScreenV2(professional: args);
        }
        return const _RouteErrorScreen(message: 'Missing profile data.');
      case '/hire':
        final args = settings.arguments;
        if (args is Professional) {
          return HireScreenV2(professional: args);
        }
        return const _RouteErrorScreen(message: 'Missing hire data.');
      default:
        return const SplashScreenV2();
    }
  }
}

class _RouteErrorScreen extends StatelessWidget {
  final String message;

  const _RouteErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FirebaseLoadingScreen extends StatelessWidget {
  const _FirebaseLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _FirebaseErrorScreen extends StatelessWidget {
  final Object? error;

  const _FirebaseErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Unable to initialize Firebase.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                error?.toString() ?? 'Unknown error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Check your Firebase configuration for this platform.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

