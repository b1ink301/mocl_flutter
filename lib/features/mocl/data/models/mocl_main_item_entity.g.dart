// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mocl_main_item_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMainItemEntityCollection on Isar {
  IsarCollection<MainItemEntity> get mainItemEntitys => this.collection();
}

const MainItemEntitySchema = CollectionSchema(
  name: r'MainList',
  id: 7762845435393755342,
  properties: {
    r'board': PropertySchema(
      id: 0,
      name: r'board',
      type: IsarType.string,
    ),
    r'orderBy': PropertySchema(
      id: 1,
      name: r'orderBy',
      type: IsarType.long,
    ),
    r'siteType': PropertySchema(
      id: 2,
      name: r'siteType',
      type: IsarType.string,
      enumMap: _MainItemEntitysiteTypeEnumValueMap,
    ),
    r'text': PropertySchema(
      id: 3,
      name: r'text',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 4,
      name: r'type',
      type: IsarType.long,
    ),
    r'url': PropertySchema(
      id: 5,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _mainItemEntityEstimateSize,
  serialize: _mainItemEntitySerialize,
  deserialize: _mainItemEntityDeserialize,
  deserializeProp: _mainItemEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _mainItemEntityGetId,
  getLinks: _mainItemEntityGetLinks,
  attach: _mainItemEntityAttach,
  version: '3.1.0+1',
);

int _mainItemEntityEstimateSize(
  MainItemEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.board.length * 3;
  bytesCount += 3 + object.siteType.name.length * 3;
  bytesCount += 3 + object.text.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _mainItemEntitySerialize(
  MainItemEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.board);
  writer.writeLong(offsets[1], object.orderBy);
  writer.writeString(offsets[2], object.siteType.name);
  writer.writeString(offsets[3], object.text);
  writer.writeLong(offsets[4], object.type);
  writer.writeString(offsets[5], object.url);
}

MainItemEntity _mainItemEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MainItemEntity();
  object.board = reader.readString(offsets[0]);
  object.id = id;
  object.orderBy = reader.readLong(offsets[1]);
  object.siteType = _MainItemEntitysiteTypeValueEnumMap[
          reader.readStringOrNull(offsets[2])] ??
      SiteType.clien;
  object.text = reader.readString(offsets[3]);
  object.type = reader.readLong(offsets[4]);
  object.url = reader.readString(offsets[5]);
  return object;
}

P _mainItemEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (_MainItemEntitysiteTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SiteType.clien) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MainItemEntitysiteTypeEnumValueMap = {
  r'clien': r'clien',
  r'damoang': r'damoang',
  r'none': r'none',
};
const _MainItemEntitysiteTypeValueEnumMap = {
  r'clien': SiteType.clien,
  r'damoang': SiteType.damoang,
  r'none': SiteType.none,
};

Id _mainItemEntityGetId(MainItemEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mainItemEntityGetLinks(MainItemEntity object) {
  return [];
}

void _mainItemEntityAttach(
    IsarCollection<dynamic> col, Id id, MainItemEntity object) {
  object.id = id;
}

extension MainItemEntityQueryWhereSort
    on QueryBuilder<MainItemEntity, MainItemEntity, QWhere> {
  QueryBuilder<MainItemEntity, MainItemEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MainItemEntityQueryWhere
    on QueryBuilder<MainItemEntity, MainItemEntity, QWhereClause> {
  QueryBuilder<MainItemEntity, MainItemEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MainItemEntityQueryFilter
    on QueryBuilder<MainItemEntity, MainItemEntity, QFilterCondition> {
  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'board',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'board',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'board',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'board',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'board',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'board',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'board',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'board',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'board',
        value: '',
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      boardIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'board',
        value: '',
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      orderByEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderBy',
        value: value,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      orderByGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderBy',
        value: value,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      orderByLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderBy',
        value: value,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      orderByBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeEqualTo(
    SiteType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'siteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeGreaterThan(
    SiteType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'siteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeLessThan(
    SiteType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'siteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeBetween(
    SiteType lower,
    SiteType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'siteType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'siteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'siteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'siteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'siteType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'siteType',
        value: '',
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      siteTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'siteType',
        value: '',
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      typeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      typeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      typeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      typeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterFilterCondition>
      urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension MainItemEntityQueryObject
    on QueryBuilder<MainItemEntity, MainItemEntity, QFilterCondition> {}

extension MainItemEntityQueryLinks
    on QueryBuilder<MainItemEntity, MainItemEntity, QFilterCondition> {}

extension MainItemEntityQuerySortBy
    on QueryBuilder<MainItemEntity, MainItemEntity, QSortBy> {
  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortByBoard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'board', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortByBoardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'board', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortByOrderBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderBy', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy>
      sortByOrderByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderBy', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortBySiteType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteType', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy>
      sortBySiteTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteType', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension MainItemEntityQuerySortThenBy
    on QueryBuilder<MainItemEntity, MainItemEntity, QSortThenBy> {
  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByBoard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'board', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByBoardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'board', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByOrderBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderBy', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy>
      thenByOrderByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderBy', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenBySiteType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteType', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy>
      thenBySiteTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteType', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension MainItemEntityQueryWhereDistinct
    on QueryBuilder<MainItemEntity, MainItemEntity, QDistinct> {
  QueryBuilder<MainItemEntity, MainItemEntity, QDistinct> distinctByBoard(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'board', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QDistinct> distinctByOrderBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderBy');
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QDistinct> distinctBySiteType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'siteType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<MainItemEntity, MainItemEntity, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension MainItemEntityQueryProperty
    on QueryBuilder<MainItemEntity, MainItemEntity, QQueryProperty> {
  QueryBuilder<MainItemEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MainItemEntity, String, QQueryOperations> boardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'board');
    });
  }

  QueryBuilder<MainItemEntity, int, QQueryOperations> orderByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderBy');
    });
  }

  QueryBuilder<MainItemEntity, SiteType, QQueryOperations> siteTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'siteType');
    });
  }

  QueryBuilder<MainItemEntity, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<MainItemEntity, int, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<MainItemEntity, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}
