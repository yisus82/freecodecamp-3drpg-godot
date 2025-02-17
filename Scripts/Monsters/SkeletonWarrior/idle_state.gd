extends Node


var ai_controller


func _ready() -> void:
	ai_controller = get_parent().get_parent()
	if ai_controller.is_awakening:
		await ai_controller.get_node("AnimationTree").animation_finished
	ai_controller.get_node("AnimationTree").get("parameters/playback").travel("Idle")

func _physics_process(_delta: float) -> void:
	if ai_controller:
		ai_controller.velocity.x = 0
		ai_controller.velocity.z = 0
