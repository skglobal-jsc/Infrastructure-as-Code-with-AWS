// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
import '../definitions.dart';
part 'allUsers_api.g.dart';

@JsonSerializable(explicitToJson: true)
class AllUsers with EquatableMixin {
  AllUsers();

  factory AllUsers.fromJson(Map<String, dynamic> json) =>
      _$AllUsersFromJson(json);

  UserConnection allUsers;

  @override
  List<Object> get props => [allUsers];
  Map<String, dynamic> toJson() => _$AllUsersToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserConnection with EquatableMixin {
  UserConnection();

  factory UserConnection.fromJson(Map<String, dynamic> json) =>
      _$UserConnectionFromJson(json);

  List<User> items;

  String nextToken;

  @override
  List<Object> get props => [items, nextToken];
  Map<String, dynamic> toJson() => _$UserConnectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class User with EquatableMixin {
  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  List<AttributesType> Attributes;

  String Username;

  List<Group> groups;

  @override
  List<Object> get props => [Attributes, Username, groups];
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AttributesType with EquatableMixin {
  AttributesType();

  factory AttributesType.fromJson(Map<String, dynamic> json) =>
      _$AttributesTypeFromJson(json);

  String Name;

  String Value;

  @override
  List<Object> get props => [Name, Value];
  Map<String, dynamic> toJson() => _$AttributesTypeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Group with EquatableMixin {
  Group();

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  String GroupName;

  int Precedence;

  String UserPoolId;

  @override
  List<Object> get props => [GroupName, Precedence, UserPoolId];
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FilterInput with EquatableMixin {
  FilterInput();

  factory FilterInput.fromJson(Map<String, dynamic> json) =>
      _$FilterInputFromJson(json);

  SearchableAttribute Name;

  SearchableType Type;

  String Value;

  @override
  List<Object> get props => [Name, Type, Value];
  Map<String, dynamic> toJson() => _$FilterInputToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AllUsersArguments extends JsonSerializable with EquatableMixin {
  AllUsersArguments({this.filter, this.limit, this.nextToken});

  factory AllUsersArguments.fromJson(Map<String, dynamic> json) =>
      _$AllUsersArgumentsFromJson(json);

  final FilterInput filter;

  final int limit;

  final String nextToken;

  @override
  List<Object> get props => [filter, limit, nextToken];
  Map<String, dynamic> toJson() => _$AllUsersArgumentsToJson(this);
}

class AllUsersQuery extends GraphQLQuery<AllUsers, AllUsersArguments> {
  AllUsersQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'AllUsers'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'filter')),
              type: NamedTypeNode(
                  name: NameNode(value: 'FilterInput'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'limit')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'nextToken')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'allUsers'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'filter'),
                    value: VariableNode(name: NameNode(value: 'filter'))),
                ArgumentNode(
                    name: NameNode(value: 'limit'),
                    value: VariableNode(name: NameNode(value: 'limit'))),
                ArgumentNode(
                    name: NameNode(value: 'nextToken'),
                    value: VariableNode(name: NameNode(value: 'nextToken')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'items'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'Attributes'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FieldNode(
                                name: NameNode(value: 'Name'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'Value'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null)
                          ])),
                      FieldNode(
                          name: NameNode(value: 'Username'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'groups'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FieldNode(
                                name: NameNode(value: 'GroupName'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'Precedence'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'UserPoolId'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null)
                          ]))
                    ])),
                FieldNode(
                    name: NameNode(value: 'nextToken'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ]))
  ]);

  @override
  final String operationName = 'all_users';

  @override
  final AllUsersArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  AllUsers parse(Map<String, dynamic> json) => AllUsers.fromJson(json);
}
