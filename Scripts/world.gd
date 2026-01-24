extends Node2D

@onready var game_manager = $GameManager
@onready var level_select = $LevelSelect
@onready var hud = $HUD
@onready var distraction_manager = $DistractionManager

@export var world_time: int = 100
@export var concentration: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_level_select_level_selected(level_name: String) -> void:
	print("level " + level_name + " selected")
	level_select.visible = false
	hud.visible = true
	
	var time_limit = game_manager.start_level(level_name)
	hud.start_timer(time_limit)
	
	distraction_manager.set_enabled(true)


func _on_game_manager_level_finished(time_taken: float, concentration_taken: int, out_of_time: bool) -> void:
	hud.stop_timer()
	
	level_select.visible = true
	#hud.visible = false
	
	world_time -= int(time_taken)
	concentration = clamp(concentration + concentration_taken, 0, 100)
	
	print("new time: " + str(world_time) + " new concentration: " + str(concentration) + " concentration taken: " + str(concentration_taken))
	
	hud.set_world_time(world_time)
	hud.set_concentration(concentration)
	
	distraction_manager.set_enabled(false)
	distraction_manager.set_concentration(concentration)
	
	if out_of_time:
		# TODO special case for when time runs out when doing a level
		pass
