import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard(
      {super.key,
      required this.name,
      required this.price,
      required this.description,
    required this.tags,
  });

  final String name;
  final int price;
  final String description;
  final List<String> tags;

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
                style: Theme.of(context).textTheme.headline3
              ),
              const SizedBox(height: 2),
              Wrap(
                children: List.generate(
                    price,
                (index) => Icon(
                          Icons.currency_pound,
                  color: Theme.of(context).primaryColor,
                          size: 15,
                ),
              ),
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
              spacing: 8,
              runSpacing: 4,
                  children: List.generate(tags.length, (index) {
                    return Text(
                  tags[index],
                  style: Theme.of(context).textTheme.headline6,
                    );
              }),
            )
            ],
          ),
      ),
    );
  }
}
