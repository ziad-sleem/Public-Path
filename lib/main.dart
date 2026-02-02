import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/config/firebase_options.dart';
import 'package:social_media_app_using_firebase/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_state.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/pages/login_page.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/core/theme/dark_mode.dart';
import 'package:social_media_app_using_firebase/core/theme/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final profileRepo = FirebaseAuthRepo();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final AuthRepo authRepo = FirebaseAuthRepo();
            final cubit = AuthCubit(authRepo: authRepo);
            // Check authentication state when app starts
            cubit.checkAuth();
            return cubit;
          },
        ),
        BlocProvider(create: (context) => ProfileCubit(profileRepo)),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightMode,
            darkTheme: darkMode,
            home: BlocConsumer<AuthCubit, AuthState>(
              bloc: BlocProvider.of<AuthCubit>(context),
              builder: (context, state) {
                if (state is Authenticated) {
                  return BlocProvider(
                    create: (context) => PostCubit(),
                    child: HomePage(),
                  );
                } else if (state is Unauthenticated) {
                  return LoginPage();
                } else {
                  // Show loading screen while checking auth state
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              },
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.grey,
                      content: Text('Incorrect Password or Email'),
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
