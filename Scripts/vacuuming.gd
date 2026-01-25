extends Node2D

@export var cursor: Texture

var dust_found: Array = [false, false, false, false]
@onready var dust = [$Dust, $Dust2, $Dust3, $Dust4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		for dust_peice in range(4):
			if dust[dust_peice].position.distance_to(event.position) < 20 and not dust_found[dust_peice]:
				dust_found[dust_peice] = true
				
				print("found dust" + str(dust_peice))
				
				vacuum_dust(dust[dust_peice])
				
				if dust_found.all(func(elem): return elem):
					print("all dust found")
					Globals.minigame_finished.emit()

func vacuum_dust(dust_peice: AnimatedSprite2D):
	dust_peice.play("vacuum")
	
	dust_peice.animation_finished.connect(func():
		dust_peice.visible = false
	)
