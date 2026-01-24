extends CanvasLayer

@onready var stopwatch: Label = $Control/UI/Stopwatch/Label
@onready var concentration_img: TextureRect = $Control/UI/Concentration
@onready var time_bar: TextureProgressBar = $Control/UI/TimeBar
@onready var windows: TextureRect = $Control/UI/Windows

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
	
	concentration_img.set_index(4 - floor(float(concentration) / 20.0))
	

func set_world_time(new: int):
	world_time = new
	time_bar.value =  world_time
	
	windows.set_index(10 - roundi(float(world_time) / 10.0))

func start_timer(time: float):
	timer = time
	timer_active = true

func stop_timer():
	timer_active = false
	stopwatch.text = ""

func set_timer_paused(paused: bool):
	print("hud timer paused: %s" % paused)
	timer_paused = paused
