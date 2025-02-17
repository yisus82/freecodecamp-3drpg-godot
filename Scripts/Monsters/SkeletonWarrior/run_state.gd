extends Node


var ai_controller
var is_running: bool


func _ready() -> void:
	ai_controller = get_parent().get_parent()
	if ai_controller.is_attacking:
		await ai_controller.get_node("AnimationTree").animation_finished
		ai_controller.is_attacking = false
	else:
		is_running = false
		ai_controller.get_node("AnimationTree").get("parameters/playback").travel("Awake")
		ai_controller.is_awakening = true
		await ai_controller.get_node("AnimationTree").animation_finished
		ai_controller.is_awakening = false
	ai_controller.look_at(ai_controller.global_transform.origin + ai_controller.direction, Vector3(0, 1, 0))
	ai_controller.get_node("AnimationTree").get("parameters/playback").travel("Run")
	is_running = true
	

func _physics_process(_delta: float) -> void:
	if ai_controller and is_running:
		ai_controller.velocity.x = ai_controller.direction.x * ai_controller.speed
		ai_controller.velocity.z = ai_controller.direction.z * ai_controller.speed
		ai_controller.look_at(ai_controller.global_transform.origin + ai_controller.direction, Vector3(0, 1, 0))
