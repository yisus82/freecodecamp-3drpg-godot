extends CanvasLayer


@onready var shop_item_scene: PackedScene = preload("res://Scenes/GUI/Shop/shop_item.tscn")

var current_item: InventoryItemData
var current_item_price: int


func _ready() -> void:
	hide()
	$"ItemInfo/ItenName".text = "Select an item"
	$"ItemInfo/ItemDescription".text = ""
	$"ItemInfo/ItemPrice".text = ""
	$"ItemInfo/ItemSprite".texture = null
	for item_name in GameManager.items:
		var item = GameManager.items[item_name]
		var shop_item_temp := shop_item_scene.instantiate()
		shop_item_temp.item_info = item
		shop_item_temp.item_price = GameManager.item_prices[item_name]
		shop_item_temp.get_node("Sprite").texture = item.texture
		$ShopItems.add_child(shop_item_temp)

func _on_buy_button_pressed() -> void:
	if GameManager.buy_item(current_item.name, current_item_price):
		get_node("../Container/Inventory").add_item(current_item.name)

func _on_close_button_pressed() -> void:
	get_tree().paused = false
	GameManager.shopping = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()
