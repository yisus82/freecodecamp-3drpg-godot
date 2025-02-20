extends CanvasLayer


var is_paused: bool


func _ready() -> void:
	get_node("Container").hide()
	get_node("Container/Inventory").hide()
	get_node("Container/Profile").hide()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		is_paused = !is_paused
		get_tree().paused = is_paused
		get_node("Container").visible = is_paused
		if is_paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_inventory_button_pressed() -> void:
	get_node("Container/VBoxContainer/InventoryButton").disabled = true
	get_node("Container/VBoxContainer/ProfileButton").disabled = false
	get_node("Container/Profile").hide()
	get_node("Container/Inventory").show()

func _on_profile_button_pressed() -> void:
	get_node("Container/VBoxContainer/InventoryButton").disabled = false
	get_node("Container/VBoxContainer/ProfileButton").disabled = true
	get_node("Container/Inventory").hide()
	get_node("Container/Profile").show()
