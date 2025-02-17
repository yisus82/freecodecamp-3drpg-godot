extends Node


var ai_controller


func _ready() -> void:
	ai_controller = get_parent().get_parent()
	if ai_controller.is_awakening:
		await ai_controller.get_node("AnimationTree").animation_finished
	ai_controller.look_at(ai_controller.global_transform.origin + ai_controller.direction, Vector3(0, 1, 0))
	ai_controller.get_node("AnimationTree").get("parameters/playback").travel("Attack")
	ai_controller.is_attacking = true

func _physics_process(_delta: float) -> void:
	if ai_controller:
		ai_controller.velocity.x = 0
		ai_controller.velocity.z = 0
