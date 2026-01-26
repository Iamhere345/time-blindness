extends Node

@export var click_target: Area2D
@export var cursor_normal: Resource
@export var cursor_hover: Resource

@export var screen_wipe: AnimationPlayer
@export var train_audio: AudioStreamPlayer2D
@export var myki_audio: AudioStreamPlayer2D

var level_finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click_target.input_event.connect(on_clicked)
	click_target.mouse_entered.connect(mouse_entered)
	click_target.mouse_exited.connect(mouse_exited)
	
	Globals.minigame_finished.connect(func(): level_finished = true)
	
	Input.set_custom_mouse_cursor(cursor_normal)
	Input.set_custom_mouse_cursor(cursor_hover, Input.CURSOR_POINTING_HAND)

func mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func on_clicked(_viewport: Node, event: InputEvent, _shapde_idx: int):
	if event is InputEventMouseButton && event.is_pressed() and not level_finished:
		level_finished = true
		print("AAAAA")
		
		myki_audio.play()
		
		screen_wipe.play("screen_wipe")
		train_audio.play()
		await screen_wipe.animation_finished
		
		Globals.minigame_finished.emit()
