extends Node2D

@onready var flag = $Flag
@onready var hurray = $Hurray

var level_finished := false

func _on_flag_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if not level_finished:
		level_finished = true
		
		hurray.play()
		Globals.minigame_finished.emit()
