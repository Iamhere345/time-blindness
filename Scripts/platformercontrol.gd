extends Node2D

@onready var flag=$flag
@onready var hurray=$hurray


func _on_flag_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	hurray.play()
	Globals.minigame_finished.emit() # Replace with function body.
