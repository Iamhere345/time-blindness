extends Node2D

signal level_finished(time_taken: float, concentration_taken: int, out_of_time: bool)
signal level_transition

@onready var timer: Timer = $MinigameTimer
@onready var screen_transition = $ScreenTransition

var level: Dictionary
var game_index: int = 0
var current_game: Node

const levels = {
	"homework": {
		"time_limit": 15.0,
		"time_taken": 25.0,
		"concentration": -25,
		"minigames": [
			"maths",
			"angles",
			"essay_writing",
		]
	},
	"work": {
		"time_limit": 15.0,
		"time_taken": 35.0,
		"concentration": -25,
		"minigames": [
			"myki",
			"stock_shelves",
			"tills",
			"microwave",
			"myki"
		]
	},
	"chores": {
		"time_limit": 10.0,
		"time_taken": 25.0,
		"concentration": -25,
		"minigames": [
			"clean_room",
			"trash",
			"dishes"
		]
	},
	"birdwatching": {
		"time_limit": 5.0,
		"time_taken": 15.0,
		"concentration": 20,
		"minigames": [
			"birdwatching"
		]
	},
	"basketball": {
		"time_limit": 3.0,
		"time_taken": 10.0,
		"concentration": 15,
		"minigames": [
			"basketball"
		]
	},
}

const minigames: Dictionary = {
	"myki": {
		"input_instr": "instr_mouse_click",
		"game_instr": "Tap on!"
	},
	"stock_shelves": {
		"input_instr": "instr_mouse_click",
		"game_instr": "Stock shelves!"
	},
	"tills": {
		"input_instr": "instr_mouse_click",
		"game_instr": "Scan items!"
	},
	"microwave": {
		"input_instr": "instr_mouse_click",
		"game_instr": "Go on break!",
	},
	"birdwatching": {
		"input_instr": "instr_mouse_move",
		"game_instr": "Find birds!"
	},
	"basketball": {
		"input_instr": "instr_ad_space",
		"game_instr": "Shoot!"
	},
	"essay_writing": {
		"input_instr": "instr_ad_space",
		"game_instr": "Finish your essay!",
	},
	"maths": {
		"input_instr": "instr_mouse_click",
		"game_instr": "Do your maths homework!",
	},
	"angles": {
		"input_instr": "instr_mouse_click",
		"game_instr": "Do more maths homework!",
	},
	"clean_room": {
		"input_instr": "instr_mouse_click",
		"game_instr": "Clean your room!",
	},
	"dishes": {
		"input_instr": "instr_mouse_click",
		"game_instr": "Do the dishes!",
	},
	"trash": {
		"input_instr": "instr_ad_space",
		"game_instr": "Take the rubbish out!",
	},
}

func _ready() -> void:
	Globals.minigame_finished.connect(next_minigame)

func start_level(level_name: String) -> Array:
	level = levels[level_name]
	game_index = 0
	
	timer.start(level["time_limit"])
	
	next_minigame()
	
	return [level["time_limit"], level["concentration"]]

func next_minigame():
	print("start next minigame")
	
	await transition_level()
	
	if game_index != len(level["minigames"]):
		var next_game = level["minigames"][game_index] + ".tscn"
		var new_minigame: PackedScene = load("res://Scenes/Minigames/" + next_game)
		
		current_game = new_minigame.instantiate()
		call_deferred("add_child", current_game)
		
		game_index += 1
	else:
		# level has finished; calculate time taken and fire signal
		var time_taken = ((level["time_limit"] - timer.time_left) / level["time_limit"]) * level["time_taken"]

		timer.stop()
		
		level_finished.emit(time_taken, level["concentration"], false)


func _on_minigame_timer_timeout() -> void:
	if not current_game:
		print("timeout outside of level")
		return
	
	print("timer timeout")
	await transition_level()
		
	level_finished.emit(level["time_taken"], level["concentration"], true)

func transition_level():
	print("index %s" % game_index)
	
	if current_game:
		current_game.set_process_input(false)
		current_game.set_process_unhandled_input(false)
		current_game.set_process_unhandled_key_input(false)
	
	screen_transition.visible = true
	timer.set_paused(true)
	Globals.hud_timer_paused.emit(true)
	
	if game_index < len(level["minigames"]):
		var minigame = minigames[level["minigames"][game_index]]
		screen_transition.play_transition(minigame["input_instr"], minigame["game_instr"])
	else:
		screen_transition.play_transition("instr_mouse_click", "Task Complete!")
	
	print("play transition")
	
	await screen_transition.screen_covered
	print("screen covered")
	
	if not current_game:
		level_transition.emit()
	
	screen_transition.transition_complete.connect((func():
		print("transition complete")
		screen_transition.visible = false
		
		timer.set_paused(false)
		Globals.hud_timer_paused.emit(false)
	), CONNECT_ONE_SHOT)
	
	if current_game:
			current_game.queue_free()
			current_game = null
