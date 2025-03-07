extends Node


@onready var grid: GridContainer = get_node("Grid")

@export var inventory_size: int = 24


func _ready() -> void:
	var rows: int = int(ceil(inventory_size * 1.0 / grid.columns))
	var parent_size: Vector2 = grid.get_parent().size
	var max_width: float = parent_size[0] / grid.columns
	var max_height: float = parent_size[1] / rows
	var max_size: float = min(max_width, max_height)
	var slot_size: int = int(max_size)
	for i in range(inventory_size):
		var slot := InventorySlot.new()
		slot.init(InventoryItemData.InventoryItemType.MAIN, Vector2(slot_size, slot_size))
		grid.add_child(slot)
	add_item("Long Sword")
	add_item("Iron Sword")
	add_item("Iron Armor")
	add_item("Small Potion")
	add_item("Small Potion")

func add_item(item_name: String) -> void:
	var item := InventoryItem.new()
	item.init(GameManager.items[item_name])
	if item.data.stackable:
		# Check if we already have the item
		for i in inventory_size:
			# Check if the slot has an item
			if grid.get_child(i).get_child_count() > 0:
				# Check if the item is the same
				if grid.get_child(i).get_child(0).data == item.data:
					# Add to data count
					grid.get_child(i).get_child(0).data.count += 1
					# Update label counter
					grid.get_child(i).get_child(0).get_child(0).text = str(grid.get_child(i).get_child(0).data.count)
					break
			else:
				# We didn't have the item in the inventory, so we create it
				grid.get_child(i).add_child(item)
				break
	else:
		# Find empty slot
		for i in inventory_size:
			if grid.get_child(i).get_child_count() == 0:
				grid.get_child(i).add_child(item)
				break
