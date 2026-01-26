extends CanvasLayer

@onready var background = $Control/Background
@onready var anim_player = $Control/Background/AnimationPlayer
@onready var input_instructions =  $Control/Background/InputInstructions
@onready var game_instructions = $Control/Background/GameInstructions

@onready var wipe_audio := $Wipe

signal transition_complete
signal screen_covered

func play_transition(input_instr: String, game_instr: String):
	var new_tex = load("res://Assets/Images/TransitionScreens/" + input_instr + ".png")
	input_instructions.texture = new_tex
	
	game_instructions.text = game_instr
	
	background.position = Vector2(-995.0, 0.0)
	anim_player.play("RESET")
	anim_player.play("screen_wipe")
	
	wipe_audio.play()
	
	anim_player.animation_finished.connect(func(_anim_name): transition_complete.emit())

func emit_screen_covered():
	screen_covered.emit()
