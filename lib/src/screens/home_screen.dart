import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/bloc/authentication/authentication_bloc.dart';
import 'package:you_choose/src/bloc/group/group_bloc.dart';
import 'package:you_choose/src/screens/authentication/welcome_screen.dart';
import 'package:you_choose/src/util/constants/constants.dart';
import 'package:you_choose/src/widgets/speed_dial.dart';


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
            title: Text((state as AuthenticationSuccess).user!.username!),

          ),
          body: BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              if (state is GroupInitial || state is GroupAdded) {
                context
                    .read<GroupBloc>()
                    .add(const LoadGroups());
                return const Center(child: CircularProgressIndicator());
              } else if (state is GroupLoaded) {
                if (state.groups.isEmpty) {
                  return const Center(
                    child: Text(Constants.textNoData),
                  );
                } else {
                  return Center(
                    child: ListView.builder(
                      itemCount: state.groups.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(state.groups[index].name!),
                            subtitle: Text(state.groups[index].id!),
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
          ),
          floatingActionButton: const SpeedDialButton(),
        );
      },
    );
  }
}
