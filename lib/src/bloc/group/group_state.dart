part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();
  
  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}
