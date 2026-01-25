extends TextureRect

const SPRITESHEET_WIDTH: int = 211

@onready var burger = $Burger
@onready var anim_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D

var bites_taken = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("burger_enter")


func _on_burger_pressed() -> void:
	if bites_taken <= 4:
		bites_taken += 1
		
		audio_player.play()
		
		if burger.texture_normal is AtlasTexture:
			burger.texture_normal.region.position.x = SPRITESHEET_WIDTH * bites_taken
	if bites_taken >= 5:
		anim_player.play("burger_exit")
		anim_player.animation_finished.connect(func(_anim_name): queue_free())
