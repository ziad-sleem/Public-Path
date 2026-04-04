import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:media_kit/media_kit.dart';
import 'package:social_media_app_using_firebase/config/firebase.dart/firebase_options.dart';
import 'package:social_media_app_using_firebase/config/DI/injection.dart';
import 'package:social_media_app_using_firebase/core/widgets/custom_snack_bar.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_state.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/auth_pages/auth_page.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/otp_pages/otp_page_provider.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/auth_pages/splash_page.dart';
import 'package:social_media_app_using_firebase/features/create_post/presentation/cubit/post_cubit.dart';
import 'package:social_media_app_using_firebase/features/create_video/presentation/cubit/create_video_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_event.dart';
import 'package:social_media_app_using_firebase/features/main_page/presentation/cubit/main_cubit.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/bloc/search_bloc.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/cubit/video_bloc.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/cubit/video_event.dart';
import 'package:social_media_app_using_firebase/features/main_page/presentation/pages/main_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/core/theme/dark_mode.dart';
import 'package:social_media_app_using_firebase/core/theme/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MediaKit.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  // Initialize Dependency Injection
  configureDependencies();

  runApp(const MyApp());

  Future.delayed(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()..checkAuth()),
        BlocProvider(create: (context) => getIt<MainCubit>()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
        BlocProvider(create: (context) => getIt<PostCubit>()..fetchAllPosts()),
        BlocProvider(create: (context) => getIt<SearchBloc>()),
        BlocProvider(
          create: (context) => getIt<VideoBloc>()..add(FetchAllVideosEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<HomeCubit>()..doEvent(FetchAllPostEvent()),
        ),
        BlocProvider(create: (context) => getIt<CreateVideoCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightMode,
            darkTheme: darkMode,
            home: BlocConsumer<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return MainPage();
                } else if (state is Unauthenticated) {
                  return const AuthPage();
                } else if (state is AuthRegistrationSuccess) {
                  return OtpScreenProvider(phoneNumber: state.phoneNumber);
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
                  CustomSnackBar.error(context, state.errorMessage);
                }
                if (state is AuthPasswordResetEmailSent) {
                  CustomSnackBar.success(
                    context,
                    "Password reset link sent! Check your email.",
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
