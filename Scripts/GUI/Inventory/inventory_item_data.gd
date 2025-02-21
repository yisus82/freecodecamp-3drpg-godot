class_name InventoryItemData
extends Resource


enum InventoryItemType {WEAPON, HEAD, BODY, LEGS, FEET, MISC, MAIN}

@export var type: InventoryItemType
@export var name: String
@export var damage: int
@export var health: int
@export var defense: int
@export var stackable: bool
@export var count: int
@export_multiline var description: String
@export var texture: Texture2D
