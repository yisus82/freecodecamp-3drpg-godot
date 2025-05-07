extends Node


signal level_up


var default_items := {
	InventoryItemData.InventoryItemType.WEAPON: preload("res://Scenes/GUI/Inventory/Resources/Default/default_sword.tres"),
	InventoryItemData.InventoryItemType.BODY: preload("res://Scenes/GUI/Inventory/Resources/Default/default_body_armor.tres"),
}

var items := {
	"Iron Sword": preload("res://Scenes/GUI/Inventory/Resources/iron_sword.tres"),
	"Long Sword": preload("res://Scenes/GUI/Inventory/Resources/long_sword.tres"),
	"Iron Armor": preload("res://Scenes/GUI/Inventory/Resources/iron_armor.tres"),
	"Small Potion": preload("res://Scenes/GUI/Inventory/Resources/small_potion.tres"),
}

var item_prices := {
	"Iron Sword": 40,
	"Long Sword": 60,
	"Iron Armor": 50,
	"Small Potion": 10,
}

var player_health: int = 10
var player_max_health: int = 10
var player_damage: int = 2
var player_defense: int = 0
var weapon_equipped: InventoryItemData = default_items[InventoryItemData.InventoryItemType.WEAPON]
var body_equipped: InventoryItemData = default_items[InventoryItemData.InventoryItemType.BODY]
var gold: int = 100
var current_exp: int = 0
var exp_to_next_level: int = 100
var player_level: int = 1
var shopping: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	player_damage = weapon_equipped.damage + body_equipped.damage
	player_defense = weapon_equipped.defense + body_equipped.defense

func reset_values() -> void:
	player_health = 10
	player_damage = 2
	player_defense = 0
	player_level = 1
	current_exp = 0
	exp_to_next_level = 100
	gold = 100
	weapon_equipped = default_items[InventoryItemData.InventoryItemType.WEAPON]
	body_equipped = default_items[InventoryItemData.InventoryItemType.BODY]

func gain_exp(amount: int) -> void:
	current_exp += amount
	while current_exp >= exp_to_next_level:
		self.emit_signal("level_up")
		player_level += 1
		player_max_health = player_level * 10
		player_health = player_max_health
		current_exp -= exp_to_next_level
		exp_to_next_level = round(exp_to_next_level * 1.3)
		exp_to_next_level = int(exp_to_next_level * pow(1.2, player_level - 1))

func damage_player(amount: int) -> bool:
	var damage_done := amount - player_defense
	if damage_done > 0:
		player_health -= damage_done
		return true
	return false

func heal_player(amount: int) -> bool:
	if player_health == player_max_health:
		return false
	player_health += amount
	if player_health > player_max_health:
		player_health = player_max_health
	return true
	
func buy_item(iten_name: String, price: int) -> bool:
	if price <= gold and iten_name in items.keys():
		gold -= price
		return true
	return false
