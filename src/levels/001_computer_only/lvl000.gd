extends Node2D
@onready var player: CharacterBody2D = %Player
@onready var tutor: CharacterBody2D = %Tutor
@onready var goals: Node2D = %Goals
@onready var ui: CanvasLayer = %UI


func _ready() -> void:
	goals.visible = false
	tutor.visible = false
	ui.visible = false
	
	create_event_timer(4, e_show_tutor)

func e_show_tutor():
	tutor.visible = true

func create_event_timer(n, function_to_call):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = n
	timer.one_shot = true
	timer.connect("timeout", function_to_call)
	timer.start()
