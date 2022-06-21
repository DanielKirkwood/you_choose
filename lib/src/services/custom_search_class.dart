import 'package:flutter/material.dart';
import 'package:you_choose/src/models/restaurant.dart';

class CustomSearchClass extends SearchDelegate {
  List<Restaurant> allDocuments = [];
  List<Restaurant> searchResult = [];
  List<Restaurant> history = [];

  CustomSearchClass(this.allDocuments);

  Widget _buildListItem(BuildContext context, Restaurant document) {
    final String? name = document.name;
    final int? price = document.price;
    final List<String>? tags = document.tags;
    final String? description = document.description;

    return Container(
        height: 200,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
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
                name!,
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
                    price!,
                    (index) => const Icon(
                          Icons.currency_pound,
                          color: Colors.blueAccent,
                          size: 15,
                        )),
              ),
              const SizedBox(height: 10),
              Text(
                description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List.generate(tags!.length, (index) {
                    return Chip(
                      label: Text(tags[index]),
                      backgroundColor: Colors.lightBlueAccent,
                      elevation: 2.0,
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }))
            ],
          ),
        ));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // this will show clear query button
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // adding a back button to close the search
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // this is run when search is completed
    searchResult.clear();

    for (Restaurant restaurant in allDocuments) {
      String name = restaurant.name.toString().toLowerCase();

      if (name.startsWith(query.toLowerCase())) {
        searchResult.add(restaurant);
        history.add(restaurant);
      }
    }

    // view a list view with the search result
    return Container(
      margin: const EdgeInsets.all(20),
      child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          scrollDirection: Axis.vertical,
          children: List.generate(searchResult.length, (index) {
            Restaurant restaurant = searchResult[index];
            return _buildListItem(context, restaurant);
          })),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This will run as user searches

    List<Restaurant> suggestionList = query.isEmpty
        ? history
        : allDocuments
            .where((Restaurant element) => element.name
                .toString()
                .toLowerCase()
                .startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: null,
        leading: Icon(query.isEmpty ? Icons.history : Icons.search),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index]
                  .name
                  .toString()
                  .substring(0, query.length),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                    text: suggestionList[index]
                        .name
                        .toString()
                        .substring(query.length),
                    style: const TextStyle(color: Color(0xff727272)))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
