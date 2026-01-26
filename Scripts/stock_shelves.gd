extends Node2D

@onready var place = $place

@onready var box_trigger = $BoxTrigger
@onready var pumpkin_trigger = $PumpkinTrigger
@onready var apple_trigger = $AppleTrigger
@onready var pineapple_trigger = $PineappleTrigger

@onready var box = $Box
@onready var fruit = $Fruit
@onready var apple = $Apple
@onready var pineapple = $Pineapple
@onready var pumpkin = $Pumpkin

var holding_fruit = false
var box_index = 0
var fruits = ["", "pineapple", "pumpkin", "apple"]

var level_finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if holding_fruit:
		fruit.position = get_viewport().get_mouse_position()
	else:
		fruit.position = Vector2(-60.0, 0.0)
	
	if pumpkin.visible and apple.visible and pineapple.visible and not level_finished:
		Globals.minigame_finished.emit()
		level_finished = true

func _on_box_trigger_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and not holding_fruit and box_index <= 3:
		box_index += 1
		
		box.play(str(box_index))
		
		holding_fruit = true
		fruit.play(fruits[box_index])



func _on_pumpkin_trigger_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and holding_fruit and fruits[box_index] == "pumpkin":
		pumpkin.visible = true
		holding_fruit = false
		place.play()


func _on_apple_trigger_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and holding_fruit and fruits[box_index] == "apple":
		apple.visible = true
		holding_fruit = false
		place.play()


func _on_pineapple_trigger_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and holding_fruit and fruits[box_index] == "pineapple":
		pineapple.visible = true
		holding_fruit = false
		place.play()
