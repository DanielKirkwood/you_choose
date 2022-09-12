import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/bloc/authentication/authentication_bloc.dart';
import 'package:you_choose/src/bloc/database/database_bloc.dart';
import 'package:you_choose/src/screens/authentication/welcome_screen.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (Route<dynamic> route) => false);
        }
      },
      buildWhen: ((previous, current) {
        if (current is AuthenticationFailure) {
          return false;
        }
        return true;
      }),
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationSignedOut());
                    })
              ],
              systemOverlayStyle:
                  const SystemUiOverlayStyle(statusBarColor: Colors.blue),
              title: Text((state as AuthenticationSuccess).username!),
            ),
            body: BlocBuilder<DatabaseBloc, DatabaseState>(
              builder: (context, state) {
                String? username = (context.read<AuthenticationBloc>().state
                        as AuthenticationSuccess)
                    .username;
                if (state is DatabaseSuccess &&
                    username !=
                        (context.read<DatabaseBloc>().state as DatabaseSuccess)
                            .username) {
                  context.read<DatabaseBloc>().add(DatabaseFetched(username));
                }
                if (state is DatabaseInitial) {
                  context.read<DatabaseBloc>().add(DatabaseFetched(username));
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DatabaseSuccess) {
                  if (state.userList.isEmpty) {
                    return const Center(
                      child: Text(Constants.textNoData),
                    );
                  } else {
                    return Center(
                      child: ListView.builder(
                        itemCount: state.userList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(state.userList[index]!.username!),
                              subtitle: Text(state.userList[index]!.email!),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ));
      },
    );
  }
}
