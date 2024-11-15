import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vivamais/src/features/auth/data/firebase_data_sources/i_firebase_data_sources.dart';
import 'package:vivamais/src/features/auth/domain/usecases/send_otp_number.dart';
import 'package:vivamais/src/features/auth/domain/usecases/sign_in_with_google_user_usecase.dart';
import 'package:vivamais/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vivamais/src/features/auth/presentation/cubit/otp_cubit/otp_cubit.dart';
import 'package:vivamais/src/features/blood/data/datasourses/i_blood_datasource.dart';
import 'package:vivamais/src/features/blood/domain/repositories/i_blood_repository.dart';
import 'package:vivamais/src/features/blood/domain/usecases/fetch_bloods_usecase.dart';
import 'package:vivamais/src/features/blood/presentation/cubit/blood_cubit.dart';
import 'package:vivamais/src/features/phone_auth/data/repositories/phone_auth_repository.dart';
import 'package:vivamais/src/features/phone_auth/domain/usecases/verify_phone_number_usecase.dart';
import 'package:vivamais/src/features/phone_auth/presentation/cubit/phone_auth_cubit.dart';
import 'package:vivamais/src/features/user/data/datasources/i_user_datasource.dart';
import 'package:vivamais/src/features/user/data/datasources/user_datasource.dart';
import 'package:vivamais/src/features/user/domain/usecases/check_if_uuid_exists_usecase.dart';
import 'package:vivamais/src/features/user/domain/usecases/create_user_usecase.dart';
import 'package:vivamais/src/features/user/domain/usecases/delete_user_usecase.dart';
import 'package:vivamais/src/features/user/domain/usecases/get_user_by_id_usecase%20.dart';
import 'package:vivamais/src/features/user/domain/usecases/update_user_usecase.dart';
import 'package:vivamais/src/features/user/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:vivamais/src/features/user/presentation/cubit/user_cubit.dart';
import 'package:vivamais/src/features/vivaMais/presentation/cubit/viva_mais_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../features/auth/data/firebase_data_sources/firebase_data_sources.dart';
import '../features/blood/data/datasourses/blood_datasource.dart';
import '../features/blood/data/repositories/blood_repository.dart';
import '../features/phone_auth/data/phone_auth_datasources/i_phone_auth_datasource.dart';
import '../features/phone_auth/data/phone_auth_datasources/phone_auth_datasource.dart';
import '../features/phone_auth/domain/repositories/i_phone_auth_repository.dart';
import '../features/phone_auth/domain/usecases/sign_in_with_credential_usecase.dart';
import '../features/user/data/repositories/user_repository.dart';
import '../features/user/domain/repositories/i_user_repository.dart';

final instance = GetIt.instance;

Future<void> init() async {
  //-------------------------- External ---------------------
  // Inicializando instâncias externas primeiro
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final networkInfo = InternetConnectionChecker.createInstance();

  // Registrando as dependências externas no GetIt
  instance.registerLazySingleton(() => firebaseFirestore);
  instance.registerLazySingleton(() => firebaseAuth);
  instance.registerLazySingleton(() => firebaseStorage);
  instance.registerLazySingleton(() => secureStorage);
  instance.registerLazySingleton(() => networkInfo);

  //-------------------------- Remote Data Source ---------------------
  // Registrando FirebaseDataSources que depende de firebaseAuth, firebaseFirestore, e firebaseStorage
  instance.registerLazySingleton<IFirebaseDataSources>(
    () => FirebaseDataSources(
      firebaseAuth: instance(),
      firebaseFirestore: instance(),
      firebaseStorage: instance(),
    ),
  );

  instance.registerLazySingleton<IFirebasePhoneAuthDatasource>(
    () => FirebasePhoneAuthDatasource(auth: instance()),
  );
  instance.registerLazySingleton<IFirebaseUserDatasource>(
    () => FirebaseUserDatasource(
        auth: instance(), firestore: instance(), storage: instance()),
  );
  instance.registerLazySingleton<IFirebaseBloodDatasource>(
    () => FirebaseBloodDatasource(
      auth: instance(),
      firestore: instance(),
    ),
  );

  //-------------------------- Repository ---------------------
  // Registrando o UserRepository que depende de IFirebaseDataSources
  instance.registerLazySingleton<IUserRepository>(
    () => UserRepository(userDatasource: instance()),
  );

  instance.registerLazySingleton<IPhoneAuthRepository>(
    () => PhoneAuthRepository(phoneDatasource: instance()),
  );

  instance.registerLazySingleton<IBloodRepository>(
    () => BloodRepository(bloodDatasource: instance()),
  );

  //-------------------------- Use Cases ---------------------
  // Registrando o UseCase que depende de IUserRepository
  instance.registerLazySingleton(
    () => SendOtpNumberUseCase(repository: instance()),
  );
  instance.registerLazySingleton(
    () => SignInWithGoogleUserUseCase(repository: instance()),
  );

  instance.registerLazySingleton(
    () => SignInWithCredentialUseCase(repository: instance()),
  );
  instance.registerLazySingleton(
    () => VerifyPhoneNumberUseCase(repository: instance()),
  );
  instance.registerLazySingleton(
    () => CheckIfUuidExistsUseCase(repository: instance()),
  );
  instance.registerLazySingleton(
    () => DeleteUserUseCase(repository: instance()),
  );
  instance.registerLazySingleton(
    () => GetUserByIdUseCase(repository: instance()),
  );
  instance.registerLazySingleton(
    () => CreateUserUseCase(repository: instance()),
  );
  instance.registerLazySingleton(
    () => UpdateUserUseCase(repository: instance()),
  );

  instance.registerLazySingleton(
    () => FetchBloodsUsecase(repository: instance()),
  );

  //-------------------------- Cubits ---------------------
  // Registrando os Cubits que dependem dos UseCases e outras classes
  instance.registerFactory(() => VivaMaisCubit());
  instance.registerFactory(() => OtpCubit(sendOtpNumberUseCase: instance()));
  instance.registerFactory(() => AuthCubit(
        signInWithGoogleUserUseCase: instance(),
      ));
  instance.registerFactory(() => PhoneAuthCubit(
        verifyPhoneNumberUseCase: instance(),
        signInWithCredentialUseCase: instance(),
      ));
  instance
      .registerFactory(() => UserCubit(checkIfUuidExistsUseCase: instance()));
  instance.registerFactory(() => RegisterCubit(
        createUserUseCase: instance(),
        getUserByIdUseCase: instance(),
        deleteUserUseCase: instance(),
        updateUserUseCase: instance(),
      ));

  instance.registerFactory(() => BloodCubit(
        fetchBloodsUsecase: instance(),
      ));
}
