import 'package:flutter/material.dart';

class GroupListTile extends StatefulWidget {
  final String name;
  final int numRestaurants;

  const GroupListTile(
      {super.key, required this.name, required this.numRestaurants});

  @override
  State<GroupListTile> createState() => _GroupListTileState();
}

class _GroupListTileState extends State<GroupListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                        widget.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              (widget.numRestaurants).toString(),
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
