import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:you_choose/src/restaurant/restaurant.dart';

class GroupTile extends StatelessWidget {
  const GroupTile(
      {
    super.key,
    required this.group,
    required this.numRestaurants,
  });

  final Group group;
  final int numRestaurants;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<RestaurantPage>(
            builder: (context) {
              return RestaurantPage(groupID: group.docID!);
            },
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Text(
                        group.name,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              (numRestaurants).toString(),
              style:
                  Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
