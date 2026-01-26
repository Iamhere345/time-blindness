extends CanvasLayer

@onready var stopwatch: Label = $Control/UI/Stopwatch/Label
@onready var concentration_img: TextureRect = $Control/UI/Concentration
@onready var time_bar: TextureProgressBar = $Control/UI/TimeBar
@onready var windows: TextureRect = $Control/UI/Windows
@onready var concentration_change = $Control/ConcentrationChange
@onready var time_change = $Control/TimeChange

var timer: float = 10.0
var timer_active: bool = false
var timer_paused: bool = false

var world_time: int = 100
var concentration: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.hud_timer_paused.connect(set_timer_paused)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_active and not timer_paused:
		timer -= delta
		stopwatch.text = str(ceili(timer))

func set_concentration(new: int):
	concentration = new
	
	print("Concentration: %s index: %s" % [concentration, roundi(float(concentration) / 20.0)])
	
	concentration_img.set_index(clamp(4 - floor(float(concentration) / 20.0), 0, 4))
	
	#await change_tween(concentration_change)

func set_world_time(new: int):
	world_time = new
	time_bar.value = world_time
	
	print("world time index: 4 - (%s / 4.0) = %s" % [world_time, 4 - roundi(float(world_time) / 20.0)])
	
	windows.set_index(4 - roundi(float(world_time) / 20.0))

func start_timer(time: float):
	timer = time
	timer_active = true

func stop_timer():
	timer_active = false
	stopwatch.text = ""

func set_timer_paused(paused: bool):
	print("hud timer paused: %s" % paused)
	timer_paused = paused

func change_tween(label: Label):
	await get_tree().create_timer(2.0).timeout
	label.visible = true

	var tween = label.create_tween().set_parallel(true)
	tween.tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
	tween.tween_property(label, "position:y", label.position.y - 50.0, 1.0)
	tween.tween_callback(func():
		print("done")
		label.visible = false
		label.modulate = Color(1.0, 1.0, 1.0, 1.0)
		label.global_position.y = label.global_position.y + 50.0
	).set_delay(1.0)
