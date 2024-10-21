// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;

import 'src/models/bag.dart';
import 'src/models/item.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 5734646974315608523),
      name: 'Bag',
      lastPropertyId: const obx_int.IdUid(3, 5912940655653160131),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 2913043497242712178),
            name: 'description',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 6977688743717899067),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 5912940655653160131),
            name: 'itemsInDb',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 8451282599434045579),
      name: 'Item',
      lastPropertyId: const obx_int.IdUid(2, 7672144424753055690),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5284212236574591023),
            name: 'description',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 7672144424753055690),
            name: 'id',
            type: 6,
            flags: 1)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
obx.Store openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) {
  return obx.Store(getObjectBoxModel(),
      directory: directory,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(2, 8451282599434045579),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Bag: obx_int.EntityDefinition<Bag>(
        model: _entities[0],
        toOneRelations: (Bag object) => [],
        toManyRelations: (Bag object) => {},
        getId: (Bag object) => object.id,
        setId: (Bag object, int id) {
          object.id = id;
        },
        objectToFB: (Bag object, fb.Builder fbb) {
          final descriptionOffset = fbb.writeString(object.description);
          final itemsInDbOffset = fbb.writeString(object.itemsInDb);
          fbb.startTable(4);
          fbb.addOffset(0, descriptionOffset);
          fbb.addInt64(1, object.id);
          fbb.addOffset(2, itemsInDbOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final descriptionParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 4, '');
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          final object = Bag(description: descriptionParam, id: idParam)
            ..itemsInDb = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 8, '');

          return object;
        }),
    Item: obx_int.EntityDefinition<Item>(
        model: _entities[1],
        toOneRelations: (Item object) => [],
        toManyRelations: (Item object) => {},
        getId: (Item object) => object.id,
        setId: (Item object, int id) {
          object.id = id;
        },
        objectToFB: (Item object, fb.Builder fbb) {
          final descriptionOffset = fbb.writeString(object.description);
          fbb.startTable(3);
          fbb.addOffset(0, descriptionOffset);
          fbb.addInt64(1, object.id);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final descriptionParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 4, '');
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          final object = Item(descriptionParam, idParam);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Bag] entity fields to define ObjectBox queries.
class Bag_ {
  /// See [Bag.description].
  static final description =
      obx.QueryStringProperty<Bag>(_entities[0].properties[0]);

  /// See [Bag.id].
  static final id = obx.QueryIntegerProperty<Bag>(_entities[0].properties[1]);

  /// See [Bag.itemsInDb].
  static final itemsInDb =
      obx.QueryStringProperty<Bag>(_entities[0].properties[2]);
}

/// [Item] entity fields to define ObjectBox queries.
class Item_ {
  /// See [Item.description].
  static final description =
      obx.QueryStringProperty<Item>(_entities[1].properties[0]);

  /// See [Item.id].
  static final id = obx.QueryIntegerProperty<Item>(_entities[1].properties[1]);
}