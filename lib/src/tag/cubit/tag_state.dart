part of 'tag_cubit.dart';

enum TagStatus { initial, loading, success, failure }

class TagState extends Equatable {
  const TagState(
      {this.tags = const <Tag>[],
      this.status = TagStatus.initial,
      this.name = const TagName.pure(),
      this.formStatus = FormzStatus.pure,
      this.errorMessage});

  final List<Tag> tags;

  final TagStatus status;

  final TagName name;

  final FormzStatus formStatus;

  final String? errorMessage;

  TagState copyWith({
    List<Tag>? tags,
    TagStatus? status,
    TagName? name,
    FormzStatus? formStatus,
    String? errorMessage,
  }) {
    return TagState(
        tags: tags ?? this.tags,
        status: status ?? this.status,
        name: name ?? this.name,
        formStatus: formStatus ?? this.formStatus,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [tags, status, name, formStatus];
}
