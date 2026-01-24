extends Node2D

@onready var num_buttons = [$"0", $"1", $"2", $"3", $"4", $"5", $"6", $"7", $"8", $"9"]
@onready var timer: Label = $Control/Timer
@onready var note: Label = $Control/TargetValue
@onready var fish = $Fish

var input_value = [0, 0, 0, 0]
var target_value = [randi_range(0, 9), randi_range(0, 9), randi_range(0, 9), randi_range(0, 9)]

var level_finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button: Area2D in num_buttons:
		button.input_event.connect(func(_viewport, event: InputEvent, _shape_idx): button_pressed(int(button.name), event))
	
	display_time(note, target_value)

func button_pressed(num: int, event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		push_num(num)
		display_time(timer, input_value)

func push_num(num: int):
	input_value[0] = input_value[1]
	input_value[1] = input_value[2]
	input_value[2] = input_value[3]
	input_value[3] = num

func display_time(label: Label, values: Array):
	label.text = "%s%s:%s%s" % values

func _on_start_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and not level_finished:
		for i in range(4):
			if input_value[i] != target_value[i]:
				return
		
		level_finished = true
		
		fish.play("spin")
		
		Globals.minigame_finished.emit()
