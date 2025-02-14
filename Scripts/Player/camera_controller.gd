extends Node3D


var cam_root_h: float = 0.0
var cam_root_v: float = 0.0
@export var cam_v_min: int = -55
@export var cam_v_max: int = 75
var h_sensitivity: float = 0.01
var v_sensitivity: float = 0.01
var h_acceleration: float = 10.0
var v_acceleration: float = 10.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cam_root_h += -event.relative.x * h_sensitivity
		cam_root_v += event.relative.y * v_sensitivity

func _physics_process(delta: float) -> void:
	cam_root_v = clamp(cam_root_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	get_node("H").rotation.y = lerpf(get_node("H").rotation.y, cam_root_h, delta * h_acceleration)
	get_node("H/V").rotation.x = lerpf(get_node("H/V").rotation.x, cam_root_v, delta * v_acceleration)
