extends CharacterBody3D


@onready var item_object_scene: PackedScene = preload("res://Scenes/Objects/item_object.tscn")
@onready var state_controller = get_node("StateMachine")

@export var player: CharacterBody3D

var speed: float = 1.0
var direction: Vector3
var health: int = 4
var damage: int = 3
var is_awakening: bool = false
var is_attacking: bool = false
var is_dying: bool = false
var just_hit: bool = false


func _ready() -> void:
	state_controller.change_state("Idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_instance_valid(player):
		direction = (player.global_transform.origin - global_transform.origin).normalized()
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
	$Skeleton_Warrior.hide()
	$VFX_Die/AnimationPlayer.play("hit")
	var rng := randi_range(2, 3)
	for i in range(rng):
		var item_object := item_object_scene.instantiate()
		item_object.position = global_position
		get_node("../../Items").add_child(item_object)
	GameManager.gain_exp(100)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "Awake" in anim_name:
		is_awakening = false
	elif "Attack" in anim_name:
		if !is_dying and player in get_node("AttackPlayerDetection").get_overlapping_bodies():
			state_controller.change_state("Attack")
	elif "Death" in anim_name:
		die()

func hit(amount: int) -> void:
	if !just_hit:
		just_hit = true
		get_node("HitTimer").start()
		health -= amount
		if health <= 0:
			is_dying = true
			state_controller.change_state("Death")
		else:
			var tween := get_tree().create_tween()
			tween.tween_property(self, "global_position", global_position - (direction / 1.5), 0.2)

func _on_hit_timer_timeout() -> void:
	just_hit = false

func _on_damage_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and is_attacking:
		body.hit(damage)


func _on_die_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
