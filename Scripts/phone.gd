extends TextureRect

var y_start: float
var x_start: float

var tween_complete = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	y_start = randf_range(0.0, 360.0 - float(size.y))
	x_start = [-79.0, 640.0].pick_random()
	position = Vector2(x_start, y_start)
	
	print(x_start)
	
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(x_start - (90.0 * sign(x_start)), y_start), 5.0)
	tween.tween_callback(func(): tween_complete = true)

func _on_button_pressed() -> void:
	print("phone go bye")
	
	if tween_complete:
		var tween = create_tween()
		tween.tween_property(self, "position", Vector2(position.x + (90.0 * sign(x_start)), y_start), 5.0)
		tween.tween_callback(func(): queue_free())
