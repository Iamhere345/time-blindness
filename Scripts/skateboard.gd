extends Node2D

@onready var sticker_place := $StickerPlace

@onready var stickers_to_place = [
	{
		"grab_item": $Item1,
		"placed": false,
	},
	{
		"grab_item": $Item2,
		"placed": false,
	},
	{
		"grab_item": $Item3,
		"placed": false
	},
]

var holding_sticker = false
var sticker: Node2D
var stickers_placed = 0

var level_finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item_info in stickers_to_place:
		var grab_item_area2d: Area2D = item_info["grab_item"].get_child(0)
		grab_item_area2d.input_event.connect(func(_viewport, event: InputEvent, _shape_idx): item_clicked(item_info["grab_item"], event))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if holding_sticker and sticker != null:
		sticker.position = get_viewport().get_mouse_position()

func item_clicked(clicked_item: Sprite2D, event: InputEvent):
	if event is InputEventMouseButton and not holding_sticker:
		sticker = clicked_item
		holding_sticker = true


func _on_trigger_1_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and sticker != null:
		print("place sticker")
		sticker.get_child(0).input_pickable = false
		
		holding_sticker = false
		sticker = null
		stickers_placed += 1
		
		sticker_place.play()
		
		if stickers_placed >= 3:
			Globals.minigame_finished.emit()
		
