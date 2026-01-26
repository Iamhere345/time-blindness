extends Node2D

signal level_finished(time_taken: float, concentration_taken: int, out_of_time: bool, time_left: float)
signal level_transition

@onready var timer: Timer = $MinigameTimer
@onready var panic_timer: Timer = $PanicTimer
@onready var clock_tick: AudioStreamPlayer2D = $ClockTick
@onready var screen_transition = $ScreenTransition

var level: Dictionary
var game_index: int = 0
var current_game: Node

const levels = {
	"homework": {
		"time_limit": 15.0,
		"time_taken": 60.0,
		"concentration": -25,
		"minigames": [
			"maths",
			"book",
			"essay_writing",
			"angles",
		]
	},
	"work": {
		"time_limit": 20.0,
		"time_taken": 60.0,
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
		"time_limit": 15.0,
		"time_taken": 30.0,
		"concentration": -25,
		"minigames": [
			"clean_room",
			"trash",
			"dishes"
		]
	},
	"birdwatching": {
		"time_limit": 5.0,
		"time_taken": 25.0,
		"concentration": 20,
		"minigames": [
			"birdwatching"
		]
	},
	"basketball": {
		"time_limit": 3.0,
		"time_taken": 20.0,
		"concentration": 20,
		"minigames": [
			"basketball"
		]
	},
	"platformer": {
		"time_limit": 5.0,
		"time_taken": 20.0,
		"concentration": 20,
		"minigames": [
			"platformer"
		]
	},
	"skateboard": {
		"time_limit": 5.0,
		"time_taken": 20.0,
		"concentration": 20,
		"minigames": [
			"skateboard"
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
		"input_instr": "instr_keyboard",
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
	"book": {
		"input_instr": "instr_d",
		"game_instr": "Read the book!",
	},
	"platformer": {
		"input_instr": "instr_ad_space",
		"game_instr": "Reach the flag!!",
	},
	"skateboard": {
		"input_instr": "instr_mouse_move",
		"game_instr": "Stickerbomb the skateboard!"
	}
}

func _ready() -> void:
	Globals.minigame_finished.connect(next_minigame)

func start_level(level_name: String) -> Array:
	level = levels[level_name]
	game_index = 0
	
	timer.start(level["time_limit"])
	panic_timer.start(level["time_limit"] * 0.75)
	
	print("time: %s panic timer: %s" % [level["time_limit"], level["time_limit"] * 0.75])
	
	next_minigame()
	
	return [level["time_limit"], level["concentration"]]

func next_minigame():
	print("start next minigame")
	
	Input.set_custom_mouse_cursor(null)
	Input.set_custom_mouse_cursor(null, Input.CURSOR_POINTING_HAND)
	
	if game_index != len(level["minigames"]):
		await transition_level(false, false)
		
		var next_game = level["minigames"][game_index] + ".tscn"
		var new_minigame: PackedScene = load("res://Scenes/Minigames/" + next_game)
		
		current_game = new_minigame.instantiate()
		call_deferred("add_child", current_game)
		
		game_index += 1
	else:
		await transition_level(true, false)
		
		# level has finished; calculate time taken and fire signal
		var time_taken = ((level["time_limit"] - timer.time_left) / level["time_limit"]) * level["time_taken"]

		var time_left = 1.0 - ((level["time_limit"] - timer.time_left) / level["time_limit"])

		print("time taken: %s actual time: %s / %s max: %s" % [time_taken, timer.time_left, level["time_limit"], level["time_taken"]])
		
		timer.stop()
		panic_timer.stop()
		clock_tick.stop()
		
		
		#print("timer time left: %s" % time_left)
		
		
		level_finished.emit(time_taken, level["concentration"], false, time_left)


func _on_minigame_timer_timeout() -> void:
	if not current_game:
		print("timeout outside of level")
		return
	
	panic_timer.stop()
	clock_tick.stop()
	
	print("timer timeout")
	await transition_level(false, true)
		
	level_finished.emit(level["time_taken"], level["concentration"], true, 0)

func transition_level(won_level: bool, timeout: bool):
	print("index %s" % game_index)
	
	if current_game:
		current_game.set_process_input(false)
		current_game.set_process_unhandled_input(false)
		current_game.set_process_unhandled_key_input(false)
	
	screen_transition.visible = true
	timer.set_paused(true)
	Globals.hud_timer_paused.emit(true)
	
	if game_index < len(level["minigames"]) and not timeout:
		var minigame = minigames[level["minigames"][game_index]]
		screen_transition.play_transition(minigame["input_instr"], minigame["game_instr"])
	else:
		if won_level:
			screen_transition.play_transition("instr_nice", "Task Complete!")
		else:
			screen_transition.play_transition("instr_loser", "Times up!")
	
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


func _on_panic_timer_timeout() -> void:
	if not current_game:
		return
	
	clock_tick.play()
