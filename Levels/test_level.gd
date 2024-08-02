extends Node2D
@onready var dialog_player: CanvasLayer = %DialogPlayer
@onready var tutor: CharacterBody2D = %Tutor
@onready var box: Area2D = $Goals/Box
@onready var goals: Node2D = %Goals
@onready var player: CharacterBody2D = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("player_reached", _on_player_reached_potential_goal)
	create_event_timer(3, e_initial_greeting)
	create_event_timer(10, e_demo_box)
	create_event_timer(18, e_task_box)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func e_initial_greeting() -> void:
	dialog_player.show_text("Hallo!")
	
func e_demo_box():
	dialog_player.show_text("Ich gehe zur Box.", 8)
	create_event_timer(2, set_box_as_target)
	
	
func e_task_box():
	dialog_player.show_text("Geh zur Box!")
	
func set_box_as_target():
	tutor.set_target(box)
	
func create_event_timer(n, function_to_call):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = n
	timer.one_shot = true
	timer.connect("timeout", function_to_call)
	timer.start()

func _on_player_reached_potential_goal(goal):
	print("player reached", goal)
