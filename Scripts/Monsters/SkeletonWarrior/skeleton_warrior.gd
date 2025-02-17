extends CharacterBody3D


@onready var state_controller = get_node("StateMachine")

@export var player: CharacterBody3D

var speed: float = 1.0
var direction: Vector3
var health: int = 4
var damage: int = 2
var is_awakening: bool = false
var is_attacking: bool = false
var is_dying: bool = false
var just_hit: bool = false


func _ready() -> void:
	state_controller.change_state("Idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if player:
		direction = (player.global_transform.origin - self.global_transform.origin).normalized()
	move_and_slide()

func _on_chase_player_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and !is_dying:
		state_controller.change_state("Run")

func _on_chase_player_detection_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and !is_dying:
		state_controller.change_state("Idle")
		
func _on_attack_player_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and !is_dying:
		state_controller.change_state("Attack")

func _on_attack_player_detection_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and !is_dying:
		state_controller.change_state("Run")

func die() -> void:
	self.queue_free()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "Awake" in anim_name:
		is_awakening = false
	elif "Attack" in anim_name:
		if !is_dying and player in get_node("AttackPlayerDetection").get_overlapping_bodies():
			state_controller.change_state("Attack")
	elif "Death" in anim_name:
		die()
