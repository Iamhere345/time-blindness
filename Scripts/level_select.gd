extends CanvasLayer

signal level_selected(name: String)

@export var tick: Texture
@export var cross: Texture

@onready var ideas = ["birdwatching", "basketball", "platformer", "skateboard"]

@onready var homework_tick = $Control/TodoList/HomeworkTick
@onready var chores_tick = $Control/TodoList/ChoresTick
@onready var work_tick = $Control/TodoList/WorkTick

@onready var homework_btn = $Control/TodoList/Homework
@onready var chores_btn = $Control/TodoList/Chores
@onready var work_btn = $Control/TodoList/Work

@onready var idea = $Control/FunIdea/Idea

var chosen_idea = ""

func _ready() -> void:
	set_idea()

func set_idea():
	chosen_idea = ideas.pick_random()
	
	var idea_tex = load("res://Assets/Images/LevelSelect/" + chosen_idea + "-idea.png")
	idea.texture_normal = idea_tex

func set_task_result(task_name: String, passed: bool):
	var result: TextureRect
	var button: Button
	
	match task_name:
		"homework":
			result = homework_tick
			button = homework_btn
		"chores":
			result = chores_tick
			button = chores_btn
		"work":
			result = work_tick
			button = work_btn
		_:
			return
	
	button.disabled = true
	
	if passed:
		result.texture = tick
	else:
		result.texture = cross
	
	result.visible = true

func _on_homework_pressed() -> void:
	level_selected.emit("homework")


func _on_chores_pressed() -> void:
	level_selected.emit("chores")


func _on_work_pressed() -> void:
	level_selected.emit("work")


func _on_idea_pressed() -> void:
	level_selected.emit(chosen_idea)


func _on_visibility_changed() -> void:
	if visible:
		set_idea()
