extends Node2D

@onready var items_to_clean = [
	{
		"trigger": $Trigger1,
		"grab_item": $Item1,
		"placed_item": $PlacedItem1,
		"clean": false,
	},
	{
		"trigger": $Trigger2,
		"grab_item": $Item2,
		"placed_item": $PlacedItem2,
		"clean": false,
	},
	{
		"trigger": $Trigger3,
		"grab_item": $Item3,
		"placed_item": $PlacedItem3,
		"clean": false
	},
]

var holding_item = false
var item: Node2D
var items_away = 0

var level_finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item_info in items_to_clean:
		var trigger: Area2D = item_info["trigger"]
		trigger.area_entered.connect(func(area: Area2D): trigger_entered(item_info, area))
		
		var grab_item_area2d: Area2D = item_info["grab_item"].get_child(0)
		grab_item_area2d.input_event.connect(func(_viewport, event: InputEvent, _shape_idx): item_clicked(item_info["grab_item"], event))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if holding_item and item != null:
		item.position = get_viewport().get_mouse_position()

func trigger_entered(item_info: Dictionary, area: Area2D):
	var held_item: Node2D = area.get_parent()
	
	if held_item == item_info["grab_item"]:
		item_info["clean"] = true
		
		holding_item = false
		item = null
		
		item_info["placed_item"].visible = true
		held_item.visible = false
		
		for other_item_info in items_to_clean:
			if not other_item_info["clean"]:
				return
	
		Globals.minigame_finished.emit()

func item_clicked(clicked_item: Sprite2D, event: InputEvent):
	if event is InputEventMouseButton and not holding_item:
		item = clicked_item
		holding_item = true
