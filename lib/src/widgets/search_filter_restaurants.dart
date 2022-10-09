import 'package:flutter/material.dart';
import 'package:you_choose/src/data/models/restaurant.dart';

class SearchFilterRestaurants extends StatefulWidget with PreferredSizeWidget {
  final List<Restaurant> searchableRestaurants;
  final Function updateResults;

  const SearchFilterRestaurants(
      {Key? key,
      required this.searchableRestaurants,
      required this.updateResults})
      : super(key: key);

  @override
  State<SearchFilterRestaurants> createState() =>
      _SearchFilterRestaurantsState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchFilterRestaurantsState extends State<SearchFilterRestaurants> {
  late TextEditingController _searchController;

  String _sortValue = 'name';
  String _ascValue = "ASC";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    searchResultsList();
  }

  Future<void> searchResultsList() async {
    List<Restaurant> showResults = [];

    if (_searchController.text.isNotEmpty) {
      for (Restaurant restaurant in widget.searchableRestaurants) {
        String name = restaurant.name.toString().toLowerCase();

        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(restaurant);
        }
      }
    } else {
      showResults = widget.searchableRestaurants;
    }

    widget.updateResults(showResults);
  }

  Future<void> showFilterDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext build) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Center(
                  child: Text(
                "Filter",
                style: TextStyle(color: Color(0xff1B3954)),
              )),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 12, right: 10),
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.sort,
                              color: Color(0xff808080),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text("Sort by"),
                                items: <String>[
                                  "name",
                                  "price",
                                  "description",
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value,
                                        style: const TextStyle(
                                            color: Color(0xff727272),
                                            fontSize: 16)),
                                  );
                                }).toList(),
                                value: _sortValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _sortValue = newValue!;
                                  });
                                  List<Restaurant> sortedList =
                                      widget.searchableRestaurants.toList()
                                        ..sort((a, b) => a
                                            .toFirestore()[_sortValue]!
                                            .compareTo(
                                                b.toFirestore()[_sortValue]!));
                                  widget.updateResults(sortedList);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8, right: 10),
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.sort_by_alpha,
                              color: Color(0xff808080),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                items: <String>[
                                  "ASC",
                                  "DESC",
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value,
                                        style: const TextStyle(
                                            color: Color(0xff727272),
                                            fontSize: 16)),
                                  );
                                }).toList(),
                                value: _ascValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _ascValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          height: 40,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                    onChanged: (value) {
                      _onSearchChanged();
                    },
                    autocorrect: true,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    )),
              ),
              IconButton(
                onPressed: () {
                  showFilterDialog(context);
                },
                icon: const Icon(Icons.filter_list),
                color: Colors.white,
              )
            ],
          ),
        ));
  }
}
