extends Node2D

signal intro_finished

@onready var anim_player := $AnimationPlayer

var finished = false

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	intro_finished.emit()
	finished = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not finished:
		anim_player.stop()
		intro_finished.emit()
		finished = true
