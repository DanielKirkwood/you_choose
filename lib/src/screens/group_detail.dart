import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/bloc/restaurant/restaurant_bloc.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/util/constants/constants.dart';
import 'package:you_choose/src/widgets/restaurant_card.dart';

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      group.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, '/add-restaurant'),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.add,
                            color: Constants.kDarkBlueColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Add Restaurant",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Icon(
                      Icons.settings,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantsLoaded && state.groupID == group.id) {
            return ListView.builder(
              itemCount: state.restaurants.length,
              itemBuilder: (BuildContext context, int index) {
                Restaurant r = state.restaurants[index];

                return RestaurantCard(
                  name: r.name,
                  price: r.price,
                  description: r.description,
                  tags: r.tags!,
                );
              },
            );
          } else {
            context
                .read<RestaurantBloc>()
                .add(LoadRestaurants(groupId: group.id));
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Constants.kDarkBlueColor,
        unselectedItemColor: Constants.kBlackColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
