import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

/// {@template PriceFilter}
/// A single Price filter status.
/// {@endtemplate}
class PriceFilter extends Equatable {
  /// {@macro PriceFilter}
  const PriceFilter({
    required this.id,
    required this.price,
    required this.value,
  });

  /// the id of the Price.
  final int id;

  /// the [Price] object.
  final Price price;

  /// the value
  final bool value;

  /// convenience copyWith method.
  PriceFilter copyWith({
    int? id,
    Price? price,
    bool? value,
  }) {
    return PriceFilter(
      id: id ?? this.id,
      price: price ?? this.price,
      value: value ?? this.value,
    );
  }

  /// created a list of filters from a given list of Prices.
  static List<PriceFilter> getFilters(List<Price> prices) {
    return prices
        .map(
          (price) => PriceFilter(
            id: price.id,
            price: price,
            value: false,
          ),
        )
        .toList();
  }

  @override
  List<Object?> get props => [id, price, value];
}
