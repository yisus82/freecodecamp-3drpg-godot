extends Node3D


@onready var warrior_scene: PackedScene = preload("res://Scenes/Monsters/SkeletonWarrior/skeleton_warrior.tscn")
@onready var walls_gridmap: GridMap = get_node("Walls")
@onready var walls2_gridmap: GridMap = get_node("Walls2")


func _ready() -> void:
	create_monsters(3, -36, -28, -38, 0)
	create_monsters(2, -24, -11, 6, 24)
	create_monsters(5, -24, 0, -38, 0)
	create_monsters(10, 0, 30, -38, 22)

func is_empty_cell(x_pos: int, z_pos: int) -> bool:
	var is_not_wall_tile := walls_gridmap.get_cell_item(Vector3i(x_pos, -1, z_pos)) == GridMap.INVALID_CELL_ITEM
	var is_not_wall_tile2 := walls2_gridmap.get_cell_item(Vector3i(x_pos, -1, z_pos)) == GridMap.INVALID_CELL_ITEM
	return is_not_wall_tile and is_not_wall_tile2

func create_monster(x_pos: int, z_pos: int) -> bool:
	is_empty_cell(x_pos, z_pos)
	var monster := warrior_scene.instantiate()
	if is_empty_cell(x_pos, z_pos):
		monster.position = Vector3i(x_pos, -2, z_pos)
		monster.player = get_node("Player")
		get_node("Monsters").add_child(monster)
		return true
	return false

func create_monsters(count: int, min_x_pos: int, max_x_pos: int, min_z_pos: int, max_z_pos: int) -> void:
	while true:
		var x_pos := randi_range(min_x_pos, max_x_pos)
		var z_pos := randi_range(min_z_pos, max_z_pos)
		if create_monster(x_pos, z_pos):
			count -= 1
			if count == 0:
				break
