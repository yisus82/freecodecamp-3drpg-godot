extends CanvasLayer


func _ready() -> void:
	hide()

func game_over() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()
	get_tree().paused = true

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	GameManager.reset_values()
