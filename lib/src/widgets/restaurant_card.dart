import 'package:flutter/material.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final int price;
  final String description;
  final List<Tag> tags;

  const RestaurantCard(
      {super.key,
      required this.name,
      required this.price,
      required this.description,
      required this.tags});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color(0xFF332d2b),
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              const SizedBox(height: 2),
              Wrap(
                children: List.generate(
                    price,
                    (index) => const Icon(
                          Icons.currency_pound,
                          color: Constants.kDarkBlueColor,
                          size: 15,
                        )),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List.generate(tags.length, (index) {
                    return Text(
                      tags[index].name,
                      style: const TextStyle(color: Constants.kDarkBlueColor),
                    );
                  }))
            ],
          ),
        ));
  }
}
