// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
import '../definitions.dart';
part 'deleteUser_api.g.dart';

@JsonSerializable(explicitToJson: true)
class DeleteUser with EquatableMixin {
  DeleteUser();

  factory DeleteUser.fromJson(Map<String, dynamic> json) =>
      _$DeleteUserFromJson(json);

  User deleteUser;

  @override
  List<Object> get props => [deleteUser];
  Map<String, dynamic> toJson() => _$DeleteUserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class User with EquatableMixin {
  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String Username;

  @override
  List<Object> get props => [Username];
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DeleteUserArguments extends JsonSerializable with EquatableMixin {
  DeleteUserArguments({this.userName});

  factory DeleteUserArguments.fromJson(Map<String, dynamic> json) =>
      _$DeleteUserArgumentsFromJson(json);

  final String userName;

  @override
  List<Object> get props => [userName];
  Map<String, dynamic> toJson() => _$DeleteUserArgumentsToJson(this);
}

class DeleteUserQuery extends GraphQLQuery<DeleteUser, DeleteUserArguments> {
  DeleteUserQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'deleteUser'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'userName')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'deleteUser'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'userName'),
                    value: VariableNode(name: NameNode(value: 'userName')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'Username'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ]))
  ]);

  @override
  final String operationName = 'delete_user';

  @override
  final DeleteUserArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  DeleteUser parse(Map<String, dynamic> json) => DeleteUser.fromJson(json);
}
