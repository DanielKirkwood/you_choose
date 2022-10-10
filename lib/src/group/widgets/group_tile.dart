import 'package:flutter/material.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/screens/group_detail.dart';

class GroupTile extends StatelessWidget {
  const GroupTile(
      {super.key, required this.group, required this.numRestaurants});

  final Group group;
  final int numRestaurants;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return GroupDetailPage(group: group);
        }));
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
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        group.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              (numRestaurants).toString(),
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
