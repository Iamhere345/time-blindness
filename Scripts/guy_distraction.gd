extends Node2D

@onready var guy = $Guy
@onready var audio_player: AudioStreamPlayer2D =  $AudioStreamPlayer2D

var in_conversation = false
var clicks = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guy.position.y = randf_range(100.0, 260.0)
	guy.play("walk")
	
	var tween = guy.create_tween()
	tween.tween_property(guy, "position", Vector2(randf_range(50.0, 640.0 - 50.0), guy.position.y), 3.0)
	tween.tween_callback(func():
		guy.play("default")
		guy.speed_scale = 0.0
		
		in_conversation = true
	)


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and in_conversation:
		clicks += 1
		guy.frame = clicks
		
		audio_player.play()
		
		if clicks == 4:
			in_conversation = false
			
			guy.play("walk")
			guy.speed_scale = 1.0
			
			var tween = guy.create_tween()
			tween.tween_property(guy, "position", Vector2(-75.0, guy.position.y), 3.0)
			tween.tween_callback(func(): queue_free())
