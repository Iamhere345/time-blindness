extends CanvasLayer

@onready var control = $Control

var distractions: Array = ["burger", "phone", "paper_plane", "guy"]
var active_distractions: Dictionary = {
	"burger": false,
	"phone": false,
	"paper_plane": false,
	"guy": false
}

var concentration: int = 100
var distractions_enabled: bool = false

func set_concentration(new: int):
	concentration = new

func set_enabled(enabled: bool):
	distractions_enabled = enabled
	
	if not enabled:
		clear_distractions()

func clear_distractions():
	for child in control.get_children():
		child.queue_free()

func new_distraction():
	var distraction_name: String = distractions.pick_random()
	
	if active_distractions[distraction_name]:
		return
	active_distractions[distraction_name] = true
	
	var distraction_packed: PackedScene = load("res://Scenes/Distractions/" + distraction_name + ".tscn")
	
	var distraction = distraction_packed.instantiate()
	control.add_child(distraction)
	
	distraction.tree_exiting.connect(func(): active_distractions[distraction_name] = false)


func _on_distraction_interval_timeout() -> void:
	if distractions_enabled:
		var rand_num = randi_range(0, 120)
		
		print("distraction: " + str(rand_num))
		
		if rand_num > concentration:
			new_distraction()
