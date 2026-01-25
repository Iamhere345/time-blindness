extends CanvasLayer

@onready var end_state: Label = $Control/EndState
@onready var score_label: Label = $Control/Score
@onready var playstyle_label: Label = $Control/Playstyle
@onready var anim_player = $Control/AnimationPlayer

func end_game(player_won: bool, levels_completed: int, concentration: int, avg_time_left: int):
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
	
	anim_player.play("fade_in")
