extends CanvasLayer

signal level_selected(name: String)


func _on_test_level_pressed() -> void:
	level_selected.emit("work")
