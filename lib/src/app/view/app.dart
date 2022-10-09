import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/repositories/repositories.dart';

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  const MyApp({
    super.key,
    required FirebaseAuthRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final FirebaseAuthRepository _authenticationRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (context) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (context) {
//             return AuthenticationBloc(
//                 FirebaseAuthRepository(), FirestoreRepository())
//               ..add(AuthenticationStarted());
//           }),
//           BlocProvider(create: (context) {
//             return FormBloc(FirebaseAuthRepository(), FirestoreRepository());
//           }),
//           BlocProvider(create: (context) {
//             return UserBloc(FirestoreRepository());
//           }),
//           BlocProvider(create: (context) {
//             return GroupBloc(FirestoreRepository(), FirebaseAuthRepository());
//           }),
//           BlocProvider(create: (context) {
//             return RestaurantBloc(FirestoreRepository());
//           }),
//         ],
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'You Choose',
//           theme: ThemeData(
//               primarySwatch: Colors.blue,
//               fontFamily: 'Poppins',
//               appBarTheme: const AppBarTheme(
//                   systemOverlayStyle: SystemUiOverlayStyle(
//                 statusBarBrightness: Brightness.light,
//                 statusBarIconBrightness: Brightness.light,
//               ))),
//           initialRoute: '/',
//           routes: {
//             '/': (context) => const BlocNavigate(screen: HomeScreen()),
//             '/add-restaurant': (context) =>
//                 const BlocNavigate(screen: AddRestaurantScreen()),
//             '/add-group': (context) =>
//                 const BlocNavigate(screen: AddGroupScreen()),
//             '/profile': (context) =>
//                 const BlocNavigate(screen: ProfileScreen()),
//           },
//         )
//     );
//   }
// }

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}

// class BlocNavigate extends StatelessWidget {
//   final Widget screen;

//   const BlocNavigate({Key? key, required this.screen}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthenticationBloc, AuthenticationState>(
//       builder: (context, state) {
//         if (state is AuthenticationSuccess) {
//           return screen;
//         } else {
//           return const WelcomeScreen();
//         }
//       },
//     );
//   }
// }
