// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mocl_read_item_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReadItemEntityCollection on Isar {
  IsarCollection<ReadItemEntity> get readItemEntitys => this.collection();
}

const ReadItemEntitySchema = CollectionSchema(
  name: r'ReadList',
  id: 855726702653181492,
  properties: {
    r'boardId': PropertySchema(
      id: 0,
      name: r'boardId',
      type: IsarType.long,
    ),
    r'siteType': PropertySchema(
      id: 1,
      name: r'siteType',
      type: IsarType.string,
      enumMap: _ReadItemEntitysiteTypeEnumValueMap,
    )
  },
  estimateSize: _readItemEntityEstimateSize,
  serialize: _readItemEntitySerialize,
  deserialize: _readItemEntityDeserialize,
  deserializeProp: _readItemEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'boardId': IndexSchema(
      id: 8343624544803511651,
      name: r'boardId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'boardId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'siteType': IndexSchema(
      id: -4092663350067807808,
      name: r'siteType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'siteType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _readItemEntityGetId,
  getLinks: _readItemEntityGetLinks,
  attach: _readItemEntityAttach,
  version: '3.1.0+1',
);

int _readItemEntityEstimateSize(
  ReadItemEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.siteType.name.length * 3;
  return bytesCount;
}

void _readItemEntitySerialize(
  ReadItemEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.boardId);
  writer.writeString(offsets[1], object.siteType.name);
}

ReadItemEntity _readItemEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadItemEntity();
  object.boardId = reader.readLong(offsets[0]);
  object.id = id;
  object.siteType = _ReadItemEntitysiteTypeValueEnumMap[
          reader.readStringOrNull(offsets[1])] ??
      SiteType.clien;
  return object;
}

P _readItemEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (_ReadItemEntitysiteTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SiteType.clien) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ReadItemEntitysiteTypeEnumValueMap = {
  r'clien': r'clien',
  r'damoang': r'damoang',
  r'none': r'none',
};
const _ReadItemEntitysiteTypeValueEnumMap = {
  r'clien': SiteType.clien,
  r'damoang': SiteType.damoang,
  r'none': SiteType.none,
};

Id _readItemEntityGetId(ReadItemEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _readItemEntityGetLinks(ReadItemEntity object) {
  return [];
}

void _readItemEntityAttach(
    IsarCollection<dynamic> col, Id id, ReadItemEntity object) {
  object.id = id;
}

extension ReadItemEntityByIndex on IsarCollection<ReadItemEntity> {
  Future<ReadItemEntity?> getByBoardId(int boardId) {
    return getByIndex(r'boardId', [boardId]);
  }

  ReadItemEntity? getByBoardIdSync(int boardId) {
    return getByIndexSync(r'boardId', [boardId]);
  }

  Future<bool> deleteByBoardId(int boardId) {
    return deleteByIndex(r'boardId', [boardId]);
  }

  bool deleteByBoardIdSync(int boardId) {
    return deleteByIndexSync(r'boardId', [boardId]);
  }

  Future<List<ReadItemEntity?>> getAllByBoardId(List<int> boardIdValues) {
    final values = boardIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'boardId', values);
  }

  List<ReadItemEntity?> getAllByBoardIdSync(List<int> boardIdValues) {
    final values = boardIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'boardId', values);
  }

  Future<int> deleteAllByBoardId(List<int> boardIdValues) {
    final values = boardIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'boardId', values);
  }

  int deleteAllByBoardIdSync(List<int> boardIdValues) {
    final values = boardIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'boardId', values);
  }

  Future<Id> putByBoardId(ReadItemEntity object) {
    return putByIndex(r'boardId', object);
  }

  Id putByBoardIdSync(ReadItemEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'boardId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBoardId(List<ReadItemEntity> objects) {
    return putAllByIndex(r'boardId', objects);
  }

  List<Id> putAllByBoardIdSync(List<ReadItemEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'boardId', objects, saveLinks: saveLinks);
  }
}

extension ReadItemEntityQueryWhereSort
    on QueryBuilder<ReadItemEntity, ReadItemEntity, QWhere> {
  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhere> anyBoardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'boardId'),
      );
    });
  }
}

extension ReadItemEntityQueryWhere
    on QueryBuilder<ReadItemEntity, ReadItemEntity, QWhereClause> {
  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause>
      boardIdEqualTo(int boardId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'boardId',
        value: [boardId],
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause>
      boardIdNotEqualTo(int boardId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'boardId',
              lower: [],
              upper: [boardId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'boardId',
              lower: [boardId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'boardId',
              lower: [boardId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'boardId',
              lower: [],
              upper: [boardId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause>
      boardIdGreaterThan(
    int boardId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'boardId',
        lower: [boardId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause>
      boardIdLessThan(
    int boardId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'boardId',
        lower: [],
        upper: [boardId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause>
      boardIdBetween(
    int lowerBoardId,
    int upperBoardId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'boardId',
        lower: [lowerBoardId],
        includeLower: includeLower,
        upper: [upperBoardId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause>
      siteTypeEqualTo(SiteType siteType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'siteType',
        value: [siteType],
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterWhereClause>
      siteTypeNotEqualTo(SiteType siteType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'siteType',
              lower: [],
              upper: [siteType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'siteType',
              lower: [siteType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'siteType',
              lower: [siteType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'siteType',
              lower: [],
              upper: [siteType],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ReadItemEntityQueryFilter
    on QueryBuilder<ReadItemEntity, ReadItemEntity, QFilterCondition> {
  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
      boardIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boardId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
      boardIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'boardId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
      boardIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'boardId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
      boardIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'boardId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
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

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
      siteTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'siteType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
      siteTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'siteType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
      siteTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'siteType',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterFilterCondition>
      siteTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'siteType',
        value: '',
      ));
    });
  }
}

extension ReadItemEntityQueryObject
    on QueryBuilder<ReadItemEntity, ReadItemEntity, QFilterCondition> {}

extension ReadItemEntityQueryLinks
    on QueryBuilder<ReadItemEntity, ReadItemEntity, QFilterCondition> {}

extension ReadItemEntityQuerySortBy
    on QueryBuilder<ReadItemEntity, ReadItemEntity, QSortBy> {
  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy> sortByBoardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boardId', Sort.asc);
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy>
      sortByBoardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boardId', Sort.desc);
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy> sortBySiteType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteType', Sort.asc);
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy>
      sortBySiteTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteType', Sort.desc);
    });
  }
}

extension ReadItemEntityQuerySortThenBy
    on QueryBuilder<ReadItemEntity, ReadItemEntity, QSortThenBy> {
  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy> thenByBoardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boardId', Sort.asc);
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy>
      thenByBoardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boardId', Sort.desc);
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy> thenBySiteType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteType', Sort.asc);
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QAfterSortBy>
      thenBySiteTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'siteType', Sort.desc);
    });
  }
}

extension ReadItemEntityQueryWhereDistinct
    on QueryBuilder<ReadItemEntity, ReadItemEntity, QDistinct> {
  QueryBuilder<ReadItemEntity, ReadItemEntity, QDistinct> distinctByBoardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'boardId');
    });
  }

  QueryBuilder<ReadItemEntity, ReadItemEntity, QDistinct> distinctBySiteType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'siteType', caseSensitive: caseSensitive);
    });
  }
}

extension ReadItemEntityQueryProperty
    on QueryBuilder<ReadItemEntity, ReadItemEntity, QQueryProperty> {
  QueryBuilder<ReadItemEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReadItemEntity, int, QQueryOperations> boardIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'boardId');
    });
  }

  QueryBuilder<ReadItemEntity, SiteType, QQueryOperations> siteTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'siteType');
    });
  }
}
