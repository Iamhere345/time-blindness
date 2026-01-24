extends Node


signal minigame_finished()
signal hud_timer_paused(paused: bool)

func _ready() -> void:
	print("connect")
	minigame_finished.connect(test)

func test():
	print("minigame finished")
