extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().paused = true
		GameManager.shopping = true
		get_node("../../GUI/Shop").show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
