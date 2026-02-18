// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/firebase_auth_repo.dart' as _i110;
import '../../features/auth/domain/repos/auth_repo.dart' as _i877;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/get_user_data_usecase.dart'
    as _i859;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/auth/domain/usecases/reset_password_usecase.dart'
    as _i474;
import '../../features/auth/domain/usecases/send_otp_usecase.dart' as _i663;
import '../../features/auth/domain/usecases/signin_with_google_usecase.dart'
    as _i780;
import '../../features/auth/domain/usecases/verify_otp_usecase.dart' as _i503;
import '../../features/auth/peresnetation/cubits/cubit/auth_cubit.dart'
    as _i774;
import '../../features/auth/peresnetation/otp/cubit/otp_cubit.dart' as _i785;
import '../../features/post/data/firebase_post_repo.dart' as _i889;
import '../../features/post/domain/repo/post_repo.dart' as _i801;
import '../../features/post/presentation/cubit/post_cubit.dart' as _i1054;
import '../../features/profile/data/firebase_profile_repo.dart' as _i1029;
import '../../features/profile/domain/repos/profile_repo.dart' as _i1007;
import '../../features/profile/presentation/cubits/cubit/profile_cubit.dart'
    as _i469;
import '../../features/search/data/firebase_search_repo.dart' as _i240;
import '../../features/search/domain/repos/search_repo.dart' as _i41;
import '../../features/search/presentation/bloc/search_bloc.dart' as _i552;
import '../cloudinary/cloudinary_service.dart' as _i816;
import '../firebase.dart/firebase_module.dart' as _i1054;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i816.CloudinaryService>(() => _i816.CloudinaryService());
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => registerModule.firebaseFirestore,
    );
    gh.lazySingleton<_i1007.ProfileRepo>(
      () => _i1029.FirebaseProfileRepo(
        firebaseFirestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i161.AuthRemoteDatasource>(
      () => _i161.AuthRemoteDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firebaseFirestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i41.SearchRepo>(
      () => _i240.FirebaseSearchRepo(
        firebaseFirestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.factory<_i552.SearchBloc>(
      () => _i552.SearchBloc(searchRepo: gh<_i41.SearchRepo>()),
    );
    gh.lazySingleton<_i877.AuthRepo>(
      () => _i110.FirebaseAuthRepo(
        authRemoteDataSource: gh<_i161.AuthRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i801.PostRepo>(
      () => _i889.FirebasePostRepo(
        firebaseFirestore: gh<_i974.FirebaseFirestore>(),
        profileRepo: gh<_i1007.ProfileRepo>(),
        authRepo: gh<_i877.AuthRepo>(),
      ),
    );
    gh.factory<_i1054.PostCubit>(
      () => _i1054.PostCubit(
        postRepo: gh<_i801.PostRepo>(),
        cloudinaryService: gh<_i816.CloudinaryService>(),
      ),
    );
    gh.factory<_i469.ProfileCubit>(
      () => _i469.ProfileCubit(
        authRepo: gh<_i877.AuthRepo>(),
        postRepo: gh<_i801.PostRepo>(),
        profileRepo: gh<_i1007.ProfileRepo>(),
      ),
    );
    gh.lazySingleton<_i17.GetCurrentUserUsecase>(
      () => _i17.GetCurrentUserUsecase(authRepo: gh<_i877.AuthRepo>()),
    );
    gh.lazySingleton<_i859.GetUserDataUsecase>(
      () => _i859.GetUserDataUsecase(authRepo: gh<_i877.AuthRepo>()),
    );
    gh.lazySingleton<_i188.LoginUsecase>(
      () => _i188.LoginUsecase(authRepo: gh<_i877.AuthRepo>()),
    );
    gh.lazySingleton<_i48.LogoutUsecase>(
      () => _i48.LogoutUsecase(authRepo: gh<_i877.AuthRepo>()),
    );
    gh.lazySingleton<_i941.RegisterUsecase>(
      () => _i941.RegisterUsecase(authRepo: gh<_i877.AuthRepo>()),
    );
    gh.lazySingleton<_i474.ResetPasswordUsecase>(
      () => _i474.ResetPasswordUsecase(authRepo: gh<_i877.AuthRepo>()),
    );
    gh.lazySingleton<_i663.SendOtpUsecase>(
      () => _i663.SendOtpUsecase(authRepo: gh<_i877.AuthRepo>()),
    );
    gh.lazySingleton<_i780.SigninWithGoogleUsecase>(
      () => _i780.SigninWithGoogleUsecase(authRepo: gh<_i877.AuthRepo>()),
    );
    gh.lazySingleton<_i503.VerifyOtpUsecase>(
      () => _i503.VerifyOtpUsecase(authRepo: gh<_i877.AuthRepo>()),
    );
    gh.factory<_i785.OtpCubit>(
      () => _i785.OtpCubit(
        gh<_i663.SendOtpUsecase>(),
        gh<_i503.VerifyOtpUsecase>(),
      ),
    );
    gh.factory<_i774.AuthCubit>(
      () => _i774.AuthCubit(
        loginUsecase: gh<_i188.LoginUsecase>(),
        registerUsecase: gh<_i941.RegisterUsecase>(),
        logoutUsecase: gh<_i48.LogoutUsecase>(),
        getCurrentUserUsecase: gh<_i17.GetCurrentUserUsecase>(),
        resetPasswordUsecase: gh<_i474.ResetPasswordUsecase>(),
        signinWithGoogleUsecase: gh<_i780.SigninWithGoogleUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i1054.RegisterModule {}
