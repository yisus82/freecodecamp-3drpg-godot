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


func reset_values() -> void:
	player_health = 10
	player_damage = 2
	player_defense = 0
	gold = 100

func damage_player(amount: int) -> int:
	player_health -= amount
	return player_health

func heal_player(amount: int) -> bool:
	if player_health == player_max_health:
		return false
	player_health += amount
	if player_health > player_max_health:
		player_health = player_max_health
	return true
