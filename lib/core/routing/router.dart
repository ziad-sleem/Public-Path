import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app_using_firebase/core/DI/injection.dart';
import 'package:social_media_app_using_firebase/core/routing/app_router.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_state.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/login_page.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/register_page.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/pages/splash_page.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/pages/main_page.dart';
import 'package:social_media_app_using_firebase/features/post/presentation/pages/upload_post_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/follower_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/following_page.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/profile_page.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/bloc/search_bloc.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/pages/search_page.dart';

// Class to refresh GoRouter based on a Stream (like Bloc state)
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  refreshListenable: GoRouterRefreshStream(getIt<AuthCubit>().stream),
  redirect: (context, state) {
    final authState = getIt<AuthCubit>().state;
    final bool loggingIn =
        state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register;
    final bool isSplash = state.matchedLocation == AppRoutes.splash;

    if (authState is Unauthenticated) {
      if (isSplash || !loggingIn) return AppRoutes.login;
    }

    if (authState is Authenticated) {
      if (loggingIn || isSplash) return AppRoutes.homePage;
    }

    return null;
  },
  routes: [
    // Splash Route
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),

    // Auth Routes
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),

    // Main App Shell (Bottom Navigation)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainPage(navigationShell: navigationShell);
      },
      branches: [
        // Branch 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.homePage,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        // Branch 2: Search
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.searchPage,
              builder: (context, state) => BlocProvider(
                create: (context) => getIt<SearchBloc>(),
                child: const SearchPage(),
              ),
            ),
          ],
        ),
        // Branch 3: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profilePage,
              builder: (context, state) {
                final currentUid = getIt<AuthCubit>().currentUser!.uid;
                return ProfilePage(uid: currentUid);
              },
            ),
          ],
        ),
      ],
    ),

    // Other Global Routes (Pushed above bottom nav)
    GoRoute(
      path: AppRoutes.postPage,
      builder: (context, state) => const UploadPostPage(),
    ),
    GoRoute(
      path: '${AppRoutes.profilePage}/:uid',
      builder: (context, state) {
        final uid = state.pathParameters['uid']!;
        return ProfilePage(uid: uid);
      },
    ),
    GoRoute(
      path: AppRoutes.editProfilePage,
      builder: (context, state) {
        final user = state.extra as dynamic; // Pass user as extra
        return EditProfilePage(user: user);
      },
    ),
    GoRoute(
      path: AppRoutes.followerPage,
      builder: (context, state) {
        final uid = state.extra as String;
        return FollowerPage(uid: uid);
      },
    ),
    GoRoute(
      path: AppRoutes.followingPage,
      builder: (context, state) {
        final uid = state.extra as String;
        return FollowingPage(uid: uid);
      },
    ),
  ],
);
