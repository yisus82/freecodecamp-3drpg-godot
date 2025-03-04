class_name InventorySlot
extends PanelContainer


@export var type: InventoryItemData.InventoryItemType


func init(slot_type: InventoryItemData.InventoryItemType, minimum_size: Vector2) -> void:
	type = slot_type
	custom_minimum_size = minimum_size

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is InventoryItem:
		if type == InventoryItemData.InventoryItemType.MAIN:
			if get_child_count() == 0:
				return true
			else:
				if type == data.get_parent().type:
					return true
				return get_child(0).data.type == data.data.type
		else:
			return data.data.type == type
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if get_child_count() > 0:
		if get_child(0) == data:
			return
		get_child(0).reparent(data.get_parent())
	data.reparent(self)

func _physics_process(_delta: float) -> void:
	match type:
		InventoryItemData.InventoryItemType.WEAPON:
			if get_child_count() > 0:
				GameManager.weapon_equipped = get_child(0).data
			else:
				GameManager.weapon_equipped = GameManager.default_items[type]
		InventoryItemData.InventoryItemType.BODY:
			if get_child_count() > 0:
				GameManager.body_equipped = get_child(0).data
			else:
				GameManager.body_equipped = GameManager.default_items[type]

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.button_mask == 0:
			if get_child_count() > 0:
				if (get_child(0).data.type == InventoryItemData.InventoryItemType.MISC):
					if GameManager.heal_player(get_child(0).data.health):
						get_child(0).data.count -= 1
						get_child(0).get_child(0).text = str(get_child(0).data.count)
						if get_child(0).data.count <= 0:
							get_child(0).queue_free()
