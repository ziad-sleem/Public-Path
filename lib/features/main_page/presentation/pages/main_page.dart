import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_using_firebase/config/DI/injection.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_cubit.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_event.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app_using_firebase/features/main_page/presentation/cubit/main_cubit.dart';
import 'package:social_media_app_using_firebase/features/main_page/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/cubits/cubit/profile_cubit.dart';
import 'package:social_media_app_using_firebase/features/profile/presentation/pages/profile_page.dart';
import 'package:social_media_app_using_firebase/features/search/presentation/pages/search_page.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/pages/vistas_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        final String userId = context.read<AuthCubit>().currentUser!.uid;
        return Scaffold(
          extendBody: true, // Allow body to extend behind bottom bar
          body: IndexedStack(
            index: state.selectedTab,
            children: [
              const HomePage(),

              VistasPage(),

              const SearchPage(),

              MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        getIt<ProfileCubit>()..fetchUserProfile(userId),
                  ),

                  BlocProvider(
                    create: (context) =>
                        getIt<HomeCubit>()
                          ..doEvent(FetchAllPostByUserIdEvent(userId: userId)),
                  ),
                ],
                child: ProfilePage(uid: userId),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: state.selectedTab,
          ),
        );
      },
    );
  }
}
