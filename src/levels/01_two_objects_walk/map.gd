extends Node2D
@onready var dialog_player: CanvasLayer = %DialogPlayer
@onready var tutor: CharacterBody2D = %Tutor
@onready var box: Area2D = $Goals/Box
@onready var goals: Node2D = %Goals
@onready var player: CharacterBody2D = %Player
@onready var ui: CanvasLayer = %UI
@onready var audio_player: AudioStreamPlayer2D = %AudioPlayer


var missions = [
	{
		"goal": "box",
		"give_demo": true
	},
	{
		"goal": "shroom",
		"give_demo": true
	},
	{
		"goal": "box",
		"give_demo": true
	},
	{
		"goal": "shroom",
		"give_demo": false
	},
	{
		"goal": "bottles",
		"give_demo": true
	},
	{
		"goal": "box",
		"give_demo": false
	},
	{
		"goal": "shroom",
		"give_demo": false
	},
	{
		"goal": "bottles",
		"give_demo": false
	},
]

var current_mission_index = 0
var current_goal_object = null
var task_started = false
var demo_started = false
var target_hot = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.visible = false
	player.connect("player_reached", _on_player_reached_potential_goal)
	tutor.connect("target_reached", _on_tutor_reached_target)
	create_event_timer(3, e_initial_greeting)
	create_event_timer(10, start_current_mission)
	

func start_current_mission():
	target_hot = false
	var goal_string = missions[current_mission_index]["goal"]
	for goal in goals.get_children():
		if goal.id == goal_string:
			current_goal_object = goal
			break
	if missions[current_mission_index]["give_demo"]:
		start_mission_demo()
	else:
		start_mission_task()
	 
	
func start_mission_demo():
	var demo_text = "Ich gehe " + current_goal_object.sentence_block
	audio_player.stream = load("res://Art/Audio/" + missions[current_mission_index]["goal"] + "_demo.mp3")
	audio_player.play()
	
	dialog_player.show_text(demo_text, 8)
	create_event_timer(2, send_tutor_to_target)
	demo_started = true
	
func send_tutor_to_target():
	tutor.set_target(current_goal_object)

func start_mission_task():
	var mission_text = "Geh " + current_goal_object.sentence_block + "!"
	audio_player.stream = load("res://Art/Audio/" + missions[current_mission_index]["goal"] + "_task.mp3")
	audio_player.play()
	dialog_player.show_text(mission_text, 0)
	task_started = true
	target_hot = true
	

func e_initial_greeting() -> void:
	dialog_player.show_text("Hallo!")
		
func give_praise_and_start_next():
	dialog_player.show_text("Super!", 3)
	current_mission_index += 1
	# if we have completed all missions, show ui and pause game
	if current_mission_index >= len(missions):
		ui.visible = true
		get_tree().paused = true
		return
	create_event_timer(4, start_current_mission)
	
	
func create_event_timer(n, function_to_call):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = n
	timer.one_shot = true
	timer.connect("timeout", function_to_call)
	timer.start()

func _on_player_reached_potential_goal(goal):
	if target_hot:
		if goal.id == current_goal_object.id:
			target_hot = false
			give_praise_and_start_next()

func _on_tutor_reached_target():
	demo_started = false
	create_event_timer(3, start_mission_task)
