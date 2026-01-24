extends Node2D

@export var MOVE_SPEED: float = 1000.0

@onready var player = $Player
@onready var shoot_ball = $ShootBall
@onready var phys_ball = $PhysicsBall

var ball_shot = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir = Input.get_axis("ui_left", "ui_right")
	
	player.position.x = clamp(player.position.x + (MOVE_SPEED * dir * delta), 72.0, 640.0 - 72.0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not ball_shot:
		ball_shot = true
		
		player.play("shoot")
		
		shoot_ball.position = player.position
		
		var tween = shoot_ball.create_tween()
		tween.tween_property(shoot_ball, "position", Vector2(shoot_ball.position.x, -40.0), 0.25)
		#tween.tween_interval(0.5)
		tween.tween_callback(drop_ball)
		

func drop_ball():
	var phys_ball_clone = phys_ball.duplicate()
	add_child(phys_ball_clone)
	
	phys_ball_clone.position = Vector2(shoot_ball.position.x, -100.0)
	phys_ball_clone.freeze = false


func _on_goal_trigger_body_entered(_body: Node2D) -> void:
	Globals.minigame_finished.emit()


func _on_fail_trigger_body_entered(_body: Node2D) -> void:
	phys_ball.position.y = -100.0
	phys_ball.set_deferred("freeze", true)
	
	player.play("default")
	ball_shot = false
	
