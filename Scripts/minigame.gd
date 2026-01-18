extends Node2D

signal complete(time_taken: int)

enum GameType {TASK, ACTIVITY}

@export var time_limit: int = 2
@export var game_type: GameType

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_timeout():
	complete.emit(time_limit)
