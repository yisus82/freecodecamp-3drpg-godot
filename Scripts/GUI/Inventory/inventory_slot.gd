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
	pass

func _gui_input(_event: InputEvent) -> void:
	pass
