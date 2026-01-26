extends CanvasLayer

@onready var page_flip = $PageFlip

@onready var cover = $Control/BookCover
@onready var pages_bg = $Control/BookPages
@onready var blurb = $Control/BookBlurb

@onready var pages = [$Control/Page12, $Control/Page34, $Control/Page56, $Control/Page78, $Control/Page910, $Control/Page1112, $Control/Page1314, $Control/Page1516, $Control/Page1718, $Control/Page1920]
var page_index = -1 # 7

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		if page_index >= 7:
			return
		
		page_flip.play()
		
		if page_index == -1:
			cover.visible = false
			
			pages_bg.visible = true
			pages[0].visible = true
			
			page_index += 1
			
			return
		
		pages[page_index].visible = false
		page_index += 1
		
		if page_index >= 7:
			blurb.visible = true
			Globals.minigame_finished.emit()
			return
		
		pages[page_index].visible = true
