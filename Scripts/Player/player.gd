extends CharacterBody3D


@onready var cam_root_h: Node = get_node("CamRoot/H")
@onready var player_mesh: Node = get_node("Knight")
@onready var animation_tree: Node = get_node("AnimationTree")
@onready var playback: Variant = animation_tree.get("parameters/playback")

@export var gravity: float = 9.8
@export var jump_force: int = 9
@export var walk_speed: int = 3
@export var run_speed: int = 10

# animation node names
var idle_node_name: String = "Idle"
var walk_node_name: String = "Walk"
var run_node_name: String = "Run"
var jump_node_name: String = "Jump"
var attack1_node_name: String = "Attack1"
var death_node_name: String = "Death"

# state machine conditions
var is_walking: bool
var is_running: bool
var is_attacking: bool
var is_dying: bool

# physics
var direction: Vector3
var horizontal_velocity: Vector3
var vertical_velocity: Vector3
var movement: Vector3
var movement_speed: int
var angular_acceleration: int
var acceleration: int
var aim_turn: float
var just_hit: bool


func _ready() -> void:
	direction = Vector3.BACK.rotated(Vector3.UP, cam_root_h.global_transform.basis.get_euler().y)
	GameManager.level_up.connect(Callable(self, "level_up"))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.015
	if event.is_action_pressed("aim"):
		direction = cam_root_h.global_transform.basis.z

func attack1() -> void:
	if idle_node_name in playback.get_current_node() or walk_node_name in playback.get_current_node() or run_node_name in playback.get_current_node():
		if Input.is_action_pressed("attack"):
			if !is_attacking:
				playback.travel(attack1_node_name)

func _physics_process(delta: float) -> void:
	var on_floor = is_on_floor()
	if !is_dying:
		attack1()
		if !on_floor:
			vertical_velocity += Vector3.DOWN * gravity * 2 * delta
		else:
			vertical_velocity = Vector3.DOWN * gravity / 10
		if Input.is_action_pressed("jump") and !is_attacking and on_floor:
			vertical_velocity = Vector3.UP * jump_force
		movement_speed = 0
		angular_acceleration = 10
		acceleration = 15
		if attack1_node_name in playback.get_current_node():
			is_attacking = true
		else:
			is_attacking = false
		var h_rot = cam_root_h.global_transform.basis.get_euler().y
		if Input.is_action_pressed("forward") or Input.is_action_pressed("backward") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"), 
								0, 
								Input.get_action_strength("forward") - Input.get_action_strength("backward"))
			direction = direction.rotated(Vector3.UP, h_rot).normalized()
			is_walking = true
			if Input.is_action_pressed("sprint"):
				movement_speed = run_speed
				is_running = true
			else:
				movement_speed = walk_speed
				is_running = false
		else:
			is_walking = false
			is_running = false
		if is_running:
			$VFX_Puff_Run.emitting = true
		else:
			$VFX_Puff_Run.emitting = false
		if Input.is_action_pressed("aim"):
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, cam_root_h.rotation.y, angular_acceleration * delta)
		else:
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, angular_acceleration * delta)
		if is_attacking:
			horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * 0.01, acceleration * delta)
		else:
			horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * movement_speed, acceleration * delta)
		velocity.x = horizontal_velocity.x + vertical_velocity.x
		velocity.y = vertical_velocity.y
		velocity.z = horizontal_velocity.z + vertical_velocity.z
		move_and_slide()
	animation_tree["parameters/conditions/is_on_floor"] = on_floor
	animation_tree["parameters/conditions/is_in_air"] = !on_floor
	animation_tree["parameters/conditions/is_walking"] = is_walking
	animation_tree["parameters/conditions/is_not_walking"] = !is_walking
	animation_tree["parameters/conditions/is_running"] = is_running
	animation_tree["parameters/conditions/is_not_running"] = !is_running
	animation_tree["parameters/conditions/is_dying"] = is_dying
	
func die() -> void:
	await get_tree().create_timer(1).timeout
	get_node("../GameOverOverlay").game_over()

func hit(amount: int) -> void:
	if !just_hit:
		$Hit.play()
		if GameManager.damage_player(amount):
			just_hit = true
			get_node("HitTimer").start()
		if GameManager.player_health <= 0:
			is_dying = true
			playback.travel(death_node_name)
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", global_position - (direction / 1.5), 0.2)
			
func level_up() -> void:
	$VFX_Level_Up/AnimationPlayer.play("init")

func _on_damage_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("monster") and is_attacking:
		body.hit(GameManager.player_damage)
		$Knight/Rig/Skeleton3D/RightHandSlot/VFX_Hit/AnimationPlayer.play("hit")
		$Damage.play()

func _on_hit_timer_timeout() -> void:
	just_hit = false

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "Death" in anim_name:
		die()
