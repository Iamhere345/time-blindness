extends CanvasLayer

@export var chars_per_key: int = 3

@onready var essay: Label = $Control/Essay

var essay_text: String
var current_text: String

var char_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	essay_text = load_essay()

func load_essay() -> String:
	var path = "res://Assets/Resources/essay.txt"
	var file = FileAccess.open(path, FileAccess.READ)
	
	return file.get_as_text()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():		
		for i in chars_per_key:
			if char_index == len(essay_text):
				Globals.minigame_finished.emit()
				return
				
			current_text += essay_text[char_index]
			char_index += 1
			
		
		essay.text = current_text
