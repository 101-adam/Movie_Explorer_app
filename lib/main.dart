import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/movie_repository.dart';
import 'data/repositories/local_database_repository.dart';
import 'logic/cubit/auth_cubit.dart';
import 'logic/cubit/home_cubit.dart';
import 'logic/cubit/search_cubit.dart';
import 'logic/cubit/favorites_cubit.dart';
import 'presentation/screens/auth_screen.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => MovieRepository()),
        RepositoryProvider(create: (_) => LocalDatabaseRepository.instance),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => HomeCubit(
              movieRepository: context.read<MovieRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SearchCubit(
              movieRepository: context.read<MovieRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => FavoritesCubit(
              localDbRepository: context.read<LocalDatabaseRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Movie Explorer',
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return HomeScreen(email: state.user.email ?? '');
              }
              return const AuthScreen();
            },
          ),
        ),
      ),
    );
  }
}