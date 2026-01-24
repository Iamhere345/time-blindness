extends Node2D

var birds_found: Array = [false, false, false]
@onready var birds = [$Bird1, $Bird2, $Bird3]
@onready var telescope = $Telescope

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		telescope.position = event.position
		
		for bird in range(0, 3):
			if birds[bird].position.distance_to(event.position) < 20 and not birds_found[bird]:
				birds_found[bird] = true
				
				print("found bird " + str(bird))
				
				scare_bird(birds[bird])
				
				if birds_found.all(func(elem): return elem):
					print("all birds found")
					Globals.minigame_finished.emit()

func scare_bird(bird: AnimatedSprite2D):
	bird.play("flying")
	
	var tween = bird.create_tween()
	tween.tween_property(bird, "position", Vector2(randf_range(bird.position.x - 50, bird.position.x + 50), -20), 2.0)
