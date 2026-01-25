extends Node2D

var grabbed_item: Sprite2D
var grabbed: bool = false
var items_grabbed: int = 0

@onready var beep_sound = $BeepSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child: Node2D in get_children():
		if child.is_in_group("till_items"):
			var area_2d: Area2D = child.get_child(0)
			area_2d.input_event.connect(func(_viewport: Node, event: InputEvent, _shape_idx: int): item_clicked(child, event))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if grabbed and grabbed_item != null:
		grabbed_item.position = get_viewport().get_mouse_position()

func item_clicked(item: Sprite2D, event: InputEvent):
	if event is InputEventMouseButton and not grabbed:
		grabbed_item = item
		grabbed = true

func _on_scanner_area_entered(area: Area2D) -> void:
	var item: Node2D = area.get_parent()
	
	if item.is_in_group("till_items"):
		grabbed = false
		grabbed_item = null
		
		item.queue_free()
		
		beep_sound.play()
		
		items_grabbed += 1
		
		if items_grabbed >= 4:
			Globals.minigame_finished.emit()
