class_name InventoryItem
extends TextureRect


@export var data: InventoryItemData


func init(d: InventoryItemData) -> void:
	data = d

func _ready() -> void:
	if data:
		expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture = data.texture
		tooltip_text = "Name: %s\nDescription: %s\nStats: %s Damage, %s Defense, %s Health" % [data.name, data.description, data.damage, data.defense, data.health]
		if data.stackable:
			var label := Label.new()
			label.text = str(data.count)
			var parent_size: Vector2 = get_parent().size
			label.position = Vector2(int(parent_size[0] * 0.8), int(parent_size[1] * 0.1))
			add_child(label)

func make_drag_preview(at_position: Vector2) -> Control:
	var texture_rect := TextureRect.new()
	texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.custom_minimum_size = size
	texture_rect.modulate.a = 0.5
	texture_rect.position = Vector2(-at_position)
	var control := Control.new()
	control.add_child(texture_rect)
	return control

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(make_drag_preview(at_position))
	return self
