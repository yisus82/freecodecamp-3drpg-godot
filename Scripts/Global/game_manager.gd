extends Node


var items := {
	"Default Body Armor": preload("res://Scenes/GUI/Inventory/Resources/Default/default_body_armor.tres"),
	"Default Sword": preload("res://Scenes/GUI/Inventory/Resources/Default/default_sword.tres"),
	"Iron Sword": preload("res://Scenes/GUI/Inventory/resources/iron_sword.tres"),
	"Long Sword": preload("res://Scenes/GUI/Inventory/resources/long_sword.tres"),
	"Small Potion": preload("res://Scenes/GUI/Inventory/resources/small_potion.tres"),
}

var player_health: int = 10
var player_max_health: int = 10
var player_damage: int = 2
var player_defense: int = 0
var right_hand_equipped: InventoryItemData
var body_equipped: InventoryItemData
var gold: int = 100
