extends Node2D

signal intro_finished

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	intro_finished.emit()
