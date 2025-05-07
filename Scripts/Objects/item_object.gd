extends Area3D


var rng: int


func _ready() -> void:
	var tween := create_tween()
	var rng_position := Vector3(randi_range(-1, 1), 1, randi_range(-1, 1))
	tween.tween_property(self, "position", position + rng_position, 0.5)
	rng = randi_range(0, 2)
	match rng:
		0:
			get_node("Body").show()
			get_node("Potion").hide()
			get_node("Sword").hide()
		1:
			get_node("Body").hide()
			get_node("Potion").show()
			get_node("Sword").hide()
		2:
			get_node("Body").hide()
			get_node("Potion").hide()
			get_node("Sword").show()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Pickup.play()
		match rng:
			0: 
				get_node("../../GUI/Container/Inventory").add_item("Iron Armor")
			1: 
				get_node("../../GUI/Container/Inventory").add_item("Small Potion")
			2: 
				get_node("../../GUI/Container/Inventory").add_item("Iron Sword")
		hide()

func _on_pickup_finished() -> void:
	queue_free()
