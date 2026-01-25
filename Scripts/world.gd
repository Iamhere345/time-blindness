extends Node2D

@onready var game_manager = $GameManager
@onready var level_select = $LevelSelect
@onready var hud = $HUD
@onready var distraction_manager = $DistractionManager
@onready var game_end = $GameEnd

@export var world_time: int = 100
@export var concentration: int = 100

var current_level: String
var tasks_completed: Dictionary = {
	"work": false,
	"homework": false,
	"chores": false,
}

var levels_completed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_level_select_level_selected(level_name: String) -> void:
	print("level " + level_name + " selected")
	current_level = level_name
	
	var level_info = game_manager.start_level(level_name)
	hud.start_timer(level_info[0])
	
	concentration = clamp(concentration + level_info[1], 0, 100)
	
	await game_manager.level_transition
	level_select.visible = false
	hud.set_concentration(concentration)
	
	distraction_manager.set_enabled(true)


func _on_game_manager_level_finished(time_taken: float, concentration_taken: int, out_of_time: bool) -> void:
	hud.stop_timer()
	
	level_select.visible = true
	
	world_time -= clamp(int(time_taken), 0, 100)
	concentration = clamp(concentration + concentration_taken, 0, 100)
	
	print("new time: " + str(world_time) + " new concentration: " + str(concentration) + " concentration taken: " + str(concentration_taken))
	
	hud.set_world_time(world_time)
	hud.set_concentration(concentration)
	
	distraction_manager.set_enabled(false)
	distraction_manager.set_concentration(concentration)
	
	tasks_completed[current_level] = true
	
	if out_of_time:
		level_select.set_task_result(current_level, false)
	else:
		level_select.set_task_result(current_level, true)
		levels_completed += 1
	
	if tasks_completed["work"] == true and tasks_completed["chores"] == true and tasks_completed["homework"] == true:
		game_end.end_game(true, levels_completed, 0, 0)
		return
	
	if world_time == 0:
		game_end.end_game(false, levels_completed)
