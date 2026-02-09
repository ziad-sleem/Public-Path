import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/config/firebase_options.dart';
import 'package:social_media_app_using_firebase/core/DI/injection.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_state.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/login_page.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/splash_page.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/pages/main_page.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/core/theme/dark_mode.dart';
import 'package:social_media_app_using_firebase/core/theme/light_mode.dart';
import 'package:social_media_app_using_firebase/core/widgets/my_text.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Dependency Injection
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()..checkAuth()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
        BlocProvider(create: (context) => getIt<PostCubit>()..fetchAllPosts()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightMode,
            darkTheme: darkMode,
            home: BlocConsumer<AuthCubit, AuthState>(
              builder: (context, state) {
                print("App Auth State: $state");
                if (state is Authenticated) {
                  return const MainPage();
                } else if (state is Unauthenticated) {
                  return const LoginPage();
                } else {
                  return const SplashPage();
                }
              },
              listener: (context, state) {
                if (state is Authenticated) {
                  // Ensure we clear any pushed pages (like RegisterPage) when we log in
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                }
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: MyText(text: state.errorMessage),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
