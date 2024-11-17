// import 'dart:convert';
// import 'dart:ui';

// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';

// // Define placeable object types
// enum PlaceableType { plant, rock, decoration, furniture }

// // Data class for placeable objects
// class PlaceableObject {
//   final String id;
//   final PlaceableType type;
//   final String spritePath;
//   final Vector2 size;
//   final bool blocksMovement;
//   final Map<String, dynamic>? properties;

//   const PlaceableObject({
//     required this.id,
//     required this.type,
//     required this.spritePath,
//     required this.size,
//     this.blocksMovement = false,
//     this.properties,
//   });

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'type': type.toString(),
//         'spritePath': spritePath,
//         'size': {
//           'x': size.x,
//           'y': size.y,
//         },
//         'blocksMovement': blocksMovement,
//         'properties': properties,
//       };

//   factory PlaceableObject.fromJson(Map<String, dynamic> json) {
//     return PlaceableObject(
//       id: json['id'],
//       type: PlaceableType.values.firstWhere(
//         (e) => e.toString() == json['type'],
//       ),
//       spritePath: json['spritePath'],
//       size: Vector2(
//         json['size']['x'].toDouble(),
//         json['size']['y'].toDouble(),
//       ),
//       blocksMovement: json['blocksMovement'],
//       properties: json['properties'],
//     );
//   }
// }

// // Data class for placed objects (instances on the grid)
// class PlacedObject {
//   final String objectId;
//   final Vector2 gridPosition;
//   final String? customId;
//   final Map<String, dynamic>? customProperties;

//   const PlacedObject({
//     required this.objectId,
//     required this.gridPosition,
//     this.customId,
//     this.customProperties,
//   });

//   Map<String, dynamic> toJson() => {
//         'objectId': objectId,
//         'position': {
//           'x': gridPosition.x,
//           'y': gridPosition.y,
//         },
//         'customId': customId,
//         'customProperties': customProperties,
//       };

//   factory PlacedObject.fromJson(Map<String, dynamic> json) {
//     return PlacedObject(
//       objectId: json['objectId'],
//       gridPosition: Vector2(
//         json['position']['x'].toDouble(),
//         json['position']['y'].toDouble(),
//       ),
//       customId: json['customId'],
//       customProperties: json['customProperties'],
//     );
//   }
// }

// // Grid system component
// class GridSystem extends Component with HasGameRef {
//   final Vector2 gridSize;
//   final Vector2 cellSize;
//   final Paint gridPaint;
//   final Paint highlightPaint;
//   final Map<String, PlaceableObject> objectTypes;
//   final Map<Vector2, PlacedObject> placedObjects = {};
//   Vector2? highlightedCell;
//   bool showGrid = true;

//   GridSystem({
//     required this.gridSize,
//     required this.cellSize,
//     required this.objectTypes,
//     Color gridColor = const Color(0x44FFFFFF),
//     Color highlightColor = const Color(0x6600FF00),
//   })  : gridPaint = Paint()
//           ..color = gridColor
//           ..style = PaintingStyle.stroke,
//         highlightPaint = Paint()
//           ..color = highlightColor
//           ..style = PaintingStyle.fill;

//   @override
//   void render(Canvas canvas) {
//     if (!showGrid) return;

//     // Draw grid
//     for (var x = 0; x < gridSize.x; x++) {
//       for (var y = 0; y < gridSize.y; y++) {
//         final rect = Rect.fromLTWH(
//           x * cellSize.x,
//           y * cellSize.y,
//           cellSize.x,
//           cellSize.y,
//         );
//         canvas.drawRect(rect, gridPaint);
//       }
//     }

//     // Draw highlighted cell
//     if (highlightedCell != null) {
//       final rect = Rect.fromLTWH(
//         highlightedCell!.x * cellSize.x,
//         highlightedCell!.y * cellSize.y,
//         cellSize.x,
//         cellSize.y,
//       );
//       canvas.drawRect(rect, highlightPaint);
//     }
//   }

//   Vector2? screenToGrid(Vector2 screenPosition) {
//     final x = (screenPosition.x / cellSize.x).floor();
//     final y = (screenPosition.y / cellSize.y).floor();

//     if (x >= 0 && x < gridSize.x && y >= 0 && y < gridSize.y) {
//       return Vector2(x.toDouble(), y.toDouble());
//     }
//     return null;
//   }

//   bool canPlaceAt(Vector2 gridPosition, String objectId) {
//     final object = objectTypes[objectId];
//     if (object == null) return false;

//     // Check if space is already occupied
//     if (placedObjects.containsKey(gridPosition)) return false;

//     // Add additional placement rules here
//     return true;
//   }

//   Future<bool> placeObject(Vector2 gridPosition, String objectId) async {
//     if (!canPlaceAt(gridPosition, objectId)) return false;

//     final placedObject = PlacedObject(
//       objectId: objectId,
//       gridPosition: gridPosition,
//     );

//     placedObjects[gridPosition] = placedObject;
//     await _addObjectSprite(placedObject);
//     return true;
//   }

//   Future<void> _addObjectSprite(PlacedObject placedObject) async {
//     final objectType = objectTypes[placedObject.objectId]!;
//     final sprite = await gameRef.loadSprite(objectType.spritePath);

//     final spriteComponent = SpriteComponent(
//       sprite: sprite,
//       position: Vector2(
//         placedObject.gridPosition.x * cellSize.x,
//         placedObject.gridPosition.y * cellSize.y,
//       ),
//       size: objectType.size,
//     );

//     gameRef.add(spriteComponent);
//   }

//   // Save grid layout to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'gridSize': {
//         'x': gridSize.x,
//         'y': gridSize.y,
//       },
//       'cellSize': {
//         'x': cellSize.x,
//         'y': cellSize.y,
//       },
//       'placedObjects': placedObjects.values.map((obj) => obj.toJson()).toList(),
//     };
//   }

//   // Load grid layout from JSON
//   Future<void> loadFromJson(Map<String, dynamic> json) async {
//     placedObjects.clear();

//     final List<dynamic> objects = json['placedObjects'];
//     for (final objData in objects) {
//       final placedObject = PlacedObject.fromJson(objData);
//       placedObjects[placedObject.gridPosition] = placedObject;
//       await _addObjectSprite(placedObject);
//     }
//   }
// }

// // Example game implementation with grid system
// class GridGameExample extends FlameGame with TapDetector {
//   late GridSystem gridSystem;
//   String? selectedObjectId;

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     // Load the sprite sheet Basic_Grass_Biom_things
//     final spriteSheet = await images.load('Basic_Grass_Biom_things.png');

//     // Define available object types
//     final objectTypes = {
//       'grass': PlaceableObject(
//         id: 'grass',
//         type: PlaceableType.plant,
//         spritePath: 'Grass.png',
//         size: Vector2(32, 32),
//       ),
//       'water': PlaceableObject(
//         id: 'water',
//         type: PlaceableType.rock,
//         spritePath: 'Water.png',
//         size: Vector2(32, 32),
//         blocksMovement: true,
//       ),
//       'clock': PlaceableObject(
//         id: 'clock',
//         type: PlaceableType.rock,
//         spritePath: 'clock.png',
//         size: Vector2(64, 64),
//         blocksMovement: true,
//       ),
//     };

//     gridSystem = GridSystem(
//       gridSize: Vector2(10, 10), // 10x10 grid
//       cellSize: Vector2(32, 32), // 32x32 pixel cells
//       objectTypes: objectTypes,
//     );

//     final backgroundImage = await loadSprite('background.png');
//     add(SpriteComponent(sprite: backgroundImage));

//     add(gridSystem);
//   }

//   @override
//   bool onTapDown(TapDownInfo info) {
//     if (selectedObjectId == null) {
//       selectedObjectId = 'water';
//     }

//     final gridPosition = gridSystem.screenToGrid(info.eventPosition.widget);
//     if (gridPosition == null) return false;

//     gridSystem.placeObject(gridPosition, selectedObjectId!);
//     return true;
//   }

//   @override
//   bool onTapUp(TapUpInfo info) {
//     debugPrint('Tapped at ${info.eventPosition.widget}');
//     // Add
//     gridSystem.highlightedCell = null;
//     return true;
//   }

//   @override
//   bool onDragUpdate(DragUpdateInfo info) {
//     final gridPosition = gridSystem.screenToGrid(info.eventPosition.widget);
//     gridSystem.highlightedCell = gridPosition;
//     return true;
//   }

//   // Save current layout
//   String saveLayout() {
//     return jsonEncode(gridSystem.toJson());
//   }

//   // Load saved layout
//   Future<void> loadLayout(String jsonString) async {
//     final layoutData = jsonDecode(jsonString);
//     await gridSystem.loadFromJson(layoutData);
//   }
// }
