extends Node


var ai_controller


func _ready() -> void:
	ai_controller = get_parent().get_parent()
	ai_controller.get_node("AnimationTree").get("parameters/playback").travel("Death")
	ai_controller.is_dying = true

func _physics_process(_delta: float) -> void:
	if ai_controller:
		ai_controller.velocity.x = 0
		ai_controller.velocity.z = 0
