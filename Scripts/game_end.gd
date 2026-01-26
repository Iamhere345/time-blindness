extends CanvasLayer

@onready var end_state: Label = $Control/EndState
@onready var score_label: Label = $Control/Score
@onready var playstyle_label: Label = $Control/Playstyle
@onready var anim_player = $Control/AnimationPlayer

func end_game(player_won: bool, levels_completed: int, concentration: int, avg_time_left: float):
	visible = true
	
	if player_won:
		end_state.text = "You got everything done!"
	else:
		end_state.text = "Out of time!"
	
	var score = ""
	
	if levels_completed >= 4:
		score = "A+"
	elif levels_completed == 3:
		score = "A"
	elif  levels_completed == 2:
		score = "C"
	elif  levels_completed == 1:
		score = "D"
	else:
		score = "F-"
	
	score_label.text = "Final Score: %s" % score
	
	var playstyle = ""
	
	if concentration > 40 and avg_time_left > 0.2:
		playstyle = "neurotypical"
	elif concentration < 20:
		playstyle = "scatterbrained"
	elif avg_time_left < 0.15:
		playstyle = "procrastinator"
	elif concentration > 40:
		playstyle = "medicated"
	elif avg_time_left > 0.2:
		playstyle = "organised"
	elif levels_completed == 0:
		playstyle = "hopeless"
	else:
		playstyle = "nerodivergent"
	
	playstyle_label.text = "Playstyle: %s"  % playstyle
	
	print("average time left: %s" % avg_time_left)
	
	anim_player.play("fade_in")


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()
