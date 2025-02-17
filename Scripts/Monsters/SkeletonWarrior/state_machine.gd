extends Node


var state = {
	"Idle": preload("res://Scripts/Monsters/SkeletonWarrior/idle_state.gd"),
	"Run": preload("res://Scripts/Monsters/SkeletonWarrior/run_state.gd"),
	"Attack": preload("res://Scripts/Monsters/SkeletonWarrior/attack_state.gd"),
	"Death": preload("res://Scripts/Monsters/SkeletonWarrior/death_state.gd"),
}


func change_state(new_state: String) -> void:
	if get_child_count() != 0:
		if !("Death" in get_child(0).name):
			get_child(0).queue_free()
	if state.has(new_state):
		var temp_state = state[new_state].new()
		temp_state.name = new_state
		add_child(temp_state)
