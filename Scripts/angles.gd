extends CanvasLayer

@export var tick: Texture
@export var cross: Texture

@onready var questions = [$Control/Question1, $Control/Question2, $Control/Question3, $Control/Question4]
var is_obtuse = [true, false, true, false]

var questions_answered = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(4):
		var question: Control = questions[i]
		var true_btn: TextureButton = question.get_child(0)
		var false_btn: TextureButton = question.get_child(1)
		
		if is_obtuse[i]:
			print(str(i) + " obtuse")
			true_btn.pressed.connect(func(): click_correct(true_btn, false_btn))
			false_btn.pressed.connect(func(): click_incorrect(false_btn, true_btn))
		else:
			false_btn.pressed.connect(func(): click_correct(false_btn, true_btn))
			true_btn.pressed.connect(func(): click_incorrect(true_btn, false_btn))

func click_correct(button: TextureButton, other_btn: TextureButton):
	button.disabled = true
	other_btn.disabled = true
	
	button.texture_disabled = tick
	
	questions_answered += 1
	if questions_answered >= 4:
		Globals.minigame_finished.emit()

func click_incorrect(button: TextureButton, other_btn: TextureButton):
	button.disabled = true
	other_btn.disabled = true
	
	button.texture_disabled = cross
	
	questions_answered += 1
	if questions_answered >= 4:
		Globals.minigame_finished.emit()
