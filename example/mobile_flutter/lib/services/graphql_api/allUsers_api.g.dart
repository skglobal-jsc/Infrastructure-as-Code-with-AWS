// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allUsers_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllUsers _$AllUsersFromJson(Map<String, dynamic> json) {
  return AllUsers()
    ..allUsers = json['allUsers'] == null
        ? null
        : UserConnection.fromJson(json['allUsers'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AllUsersToJson(AllUsers instance) => <String, dynamic>{
      'allUsers': instance.allUsers?.toJson(),
    };

UserConnection _$UserConnectionFromJson(Map<String, dynamic> json) {
  return UserConnection()
    ..items = (json['items'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..nextToken = json['nextToken'] as String;
}

Map<String, dynamic> _$UserConnectionToJson(UserConnection instance) =>
    <String, dynamic>{
      'items': instance.items?.map((e) => e?.toJson())?.toList(),
      'nextToken': instance.nextToken,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..Attributes = (json['Attributes'] as List)
        ?.map((e) => e == null
            ? null
            : AttributesType.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..Username = json['Username'] as String
    ..groups = (json['groups'] as List)
        ?.map(
            (e) => e == null ? null : Group.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Attributes': instance.Attributes?.map((e) => e?.toJson())?.toList(),
      'Username': instance.Username,
      'groups': instance.groups?.map((e) => e?.toJson())?.toList(),
    };

AttributesType _$AttributesTypeFromJson(Map<String, dynamic> json) {
  return AttributesType()
    ..Name = json['Name'] as String
    ..Value = json['Value'] as String;
}

Map<String, dynamic> _$AttributesTypeToJson(AttributesType instance) =>
    <String, dynamic>{
      'Name': instance.Name,
      'Value': instance.Value,
    };

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group()
    ..GroupName = json['GroupName'] as String
    ..Precedence = json['Precedence'] as int
    ..UserPoolId = json['UserPoolId'] as String;
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'GroupName': instance.GroupName,
      'Precedence': instance.Precedence,
      'UserPoolId': instance.UserPoolId,
    };

FilterInput _$FilterInputFromJson(Map<String, dynamic> json) {
  return FilterInput()
    ..Name = _$enumDecodeNullable(_$SearchableAttributeEnumMap, json['Name'])
    ..Type = _$enumDecodeNullable(_$SearchableTypeEnumMap, json['Type'])
    ..Value = json['Value'] as String;
}

Map<String, dynamic> _$FilterInputToJson(FilterInput instance) =>
    <String, dynamic>{
      'Name': _$SearchableAttributeEnumMap[instance.Name],
      'Type': _$SearchableTypeEnumMap[instance.Type],
      'Value': instance.Value,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SearchableAttributeEnumMap = {
  SearchableAttribute.email: 'email',
  SearchableAttribute.name: 'name',
  SearchableAttribute.username: 'username',
};

const _$SearchableTypeEnumMap = {
  SearchableType.BEGIN_WITH: 'BEGIN_WITH',
  SearchableType.EXTRACTLY: 'EXTRACTLY',
};

AllUsersArguments _$AllUsersArgumentsFromJson(Map<String, dynamic> json) {
  return AllUsersArguments(
    filter: json['filter'] == null
        ? null
        : FilterInput.fromJson(json['filter'] as Map<String, dynamic>),
    limit: json['limit'] as int,
    nextToken: json['nextToken'] as String,
  );
}

Map<String, dynamic> _$AllUsersArgumentsToJson(AllUsersArguments instance) =>
    <String, dynamic>{
      'filter': instance.filter?.toJson(),
      'limit': instance.limit,
      'nextToken': instance.nextToken,
    };
