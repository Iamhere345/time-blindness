extends Node2D

const RACK_PADDING: float = 30.0

@export var cursor: Texture
@export var pointing: Texture

@onready var water = $water

@onready var sink = $Sink
@onready var rack_shape = $DishRack/CollisionShape2D

var grabbed_item: Sprite2D
var grabbed: bool = false
var items_cleaned: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
	
	for child: Node2D in get_children():
		if child.is_in_group("dishes"):
			var area_2d: Area2D = child.get_child(0)
			area_2d.input_event.connect(func(_viewport: Node, event: InputEvent, _shape_idx: int): item_clicked(child, event))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if grabbed and grabbed_item != null:
		grabbed_item.position = get_viewport().get_mouse_position()

func item_clicked(item: Sprite2D, event: InputEvent):
	if event is InputEventMouseButton and not grabbed and not item.is_in_group("washed_dishes"):
		grabbed_item = item
		grabbed = true

func _on_sink_area_entered(area: Area2D) -> void:
	var item: Sprite2D = area.get_parent()
	
	if item.is_in_group("dishes"):
		item.frame = 1
		water.play()
		item.add_to_group("washed_dishes")


func _on_dish_rack_area_entered(area: Area2D) -> void:
	var item: Sprite2D = area.get_parent()
	
	if item.is_in_group("washed_dishes"):
		grabbed = false
		grabbed_item = null
		
		item.position = Vector2(
			randf_range(rack_shape.position.x - (rack_shape.shape.size.x / 2) + RACK_PADDING, 640.0 - RACK_PADDING),
			randf_range(0.0 + RACK_PADDING, 280.0 - RACK_PADDING)
		)
		
		items_cleaned += 1
		
		if items_cleaned >= 4:
			Globals.minigame_finished.emit()
