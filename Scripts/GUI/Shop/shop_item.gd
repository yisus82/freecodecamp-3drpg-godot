extends Panel


var item_info: InventoryItemData
var item_price: int


func _on_button_pressed() -> void:
	get_node("../..").current_item = item_info
	get_node("../..").current_item_price = item_price
	$"../../ItemInfo".show()
	$"../../ItemInfo/ItenName".text = item_info.name
	$"../../ItemInfo/ItemDescription".text = "%s\nStats: %s Damage, %s Defense, %s Health" % [item_info.description, item_info.damage, item_info.defense, item_info.health]
	$"../../ItemInfo/ItemPrice".text = "Price: %s" % [item_price]
	$"../../ItemInfo/ItemSprite".texture = item_info.texture
