extends Node2D

@onready var game_manager = $GameManager
@onready var level_select = $LevelSelect
@onready var hud = $HUD
@onready var distraction_manager = $DistractionManager
@onready var game_end = $GameEnd

@export var world_time: int = 100
@export var concentration: int = 100

@onready var soundtrack_1: AudioStreamPlayer2D = $Soundtrack
@onready var soundtrack_2: AudioStreamPlayer2D = $Soundtrack2

var avg_level_time: float = 0
var levels_attempted: float = 0

var current_level: String
var tasks_completed: Dictionary = {
	"work": false,
	"homework": false,
	"chores": false,
}
var tasks_failed: Dictionary = {
	"work": false,
	"homework": false,
	"chores": false
}

var levels_completed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.set_concentration(concentration)
	hud.set_world_time(world_time)

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


func _on_game_manager_level_finished(time_taken: float, concentration_taken: int, out_of_time: bool, time_left: float) -> void:
	hud.stop_timer()
	
	level_select.visible = true
	
	world_time -= clamp(int(time_taken), 0, 100)
	concentration = clamp(concentration + concentration_taken, 0, 100)
	
	#set_music_timescale(clamp(1.0 + (1.0 - (float(world_time) / 100.0)), 1.0, 2.0))
	
	if world_time <= 50.0:
		intensify_music()
	
	levels_attempted += 1
	avg_level_time += time_left
	
	print("new time: " + str(world_time) + " new concentration: " + str(concentration) + " concentration taken: " + str(concentration_taken))
	
	hud.set_world_time(world_time)
	hud.set_concentration(concentration)
	
	distraction_manager.set_enabled(false)
	distraction_manager.set_concentration(concentration)
	
	if out_of_time:
		tasks_failed[current_level] = true
		level_select.set_task_result(current_level, false)
	else:
		level_select.set_task_result(current_level, true)
		tasks_completed[current_level] = true
		levels_completed += 1
	
	print("%s / %s = %s" % [avg_level_time, levels_attempted, avg_level_time / levels_attempted])
	
	if tasks_completed["work"] == true and tasks_completed["chores"] == true and tasks_completed["homework"] == true:
		game_end.end_game(true, levels_completed, concentration, avg_level_time / levels_attempted)
		return
	elif (tasks_completed["work"] or tasks_failed["work"]) and (tasks_completed["chores"] or tasks_failed["chores"]) and (tasks_completed["homework"] or tasks_failed["homework"]):
		game_end.end_game(false, levels_completed, concentration, avg_level_time / levels_attempted)
		
	if world_time == 0:
		game_end.end_game(false, levels_completed, concentration, avg_level_time / levels_attempted)


func _on_intro_intro_finished() -> void:
	$IntroLayer.visible = false

func intensify_music():
	var old_song = create_tween()
	old_song.tween_property(soundtrack_1, "volume_db", -80.0, 2.0)
	old_song.tween_callback(func(): soundtrack_1.stop())
	
	soundtrack_2.play(soundtrack_1.get_playback_position())
	var new_song = create_tween()
	new_song.tween_property(soundtrack_2, "volume_db", 0.0, 2.0)
