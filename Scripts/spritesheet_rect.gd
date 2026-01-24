extends TextureRect

@export var SPRITE_WIDTH: float = 179.0

func set_index(i):
	if texture is AtlasTexture:
		texture.region.position.x = i * SPRITE_WIDTH
