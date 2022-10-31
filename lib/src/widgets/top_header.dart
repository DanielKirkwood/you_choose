import 'package:flutter/material.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class TopHeader extends StatelessWidget {
  const TopHeader(
      {super.key,
      required this.title,
      required this.onPress,
    this.label = 'Add New',
  });

  final String title;
  final String label;
  final void Function() onPress;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline1,
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Constants.kGreyColor,
              ),
              child: InkWell(
                onTap: onPress,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      label,
                      style:
                          const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
