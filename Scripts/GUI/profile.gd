extends Control


func _process(_delta: float) -> void:
	get_node("StatsLabel").text = "
	Player Health: %s
	\nPlayer Attack: %s
	\nPlayer Defense: %s
	\nPlayer Level: %s
	\nPlayer Exp: %s / %s
	\nGold: %s" % [GameManager.player_health,
	GameManager.player_damage,
	GameManager.player_defense,
	GameManager.player_level, 
	GameManager.current_exp, 
	GameManager.exp_to_next_level,
	GameManager.gold]
