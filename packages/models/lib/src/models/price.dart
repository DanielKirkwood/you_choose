import 'package:equatable/equatable.dart';

/// {@template price}
/// A single price.
/// {@endtemplate}
class Price extends Equatable {
  ///{@macro price}
  const Price({
    required this.id,
    required this.price,
  });

  /// the id
  final int id;

  /// the price value.
  final int price;

  /// the list of prices.
  static List<Price> prices = const [
    Price(id: 1, price: 1),
    Price(id: 2, price: 2),
    Price(id: 3, price: 3),
    Price(id: 4, price: 4),
  ];

  @override
  String toString() {
    return '£' * price;
  }

  @override
  List<Object?> get props => [id, price];
}
