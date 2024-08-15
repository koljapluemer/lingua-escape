extends Node2D
@onready var player: CharacterBody2D = %Player
@onready var tutor: CharacterBody2D = %Tutor
@onready var goals: Node2D = %Goals
@onready var ui: CanvasLayer = %UI
@onready var objects: Node2D = %Objects
@onready var dialog_player: CanvasLayer = %DialogPlayer
@onready var audio_player: AudioStreamPlayer2D = %AudioPlayer


const FINGERPLOP = preload("res://src/levels/universal_assets/fingerplop.mp3")
const WIN_JINGLE = preload("res://src/levels/universal_assets/win_jingle.wav")


var missions = [
	{
		"goal": "laptop",
		"give_demo": true
	}
]
var current_mission_index = 0
var current_goal_object = null
var target_hot = false


func _ready() -> void:
	objects.visible = false
	tutor.visible = false
	ui.visible = false

	player.connect("player_reached", _on_player_reached_potential_goal)
	tutor.connect("target_reached", _on_tutor_reached_target)
	
	create_event_timer(4, e_show_tutor)



func create_event_timer(n, function_to_call):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = n
	timer.one_shot = true
	timer.connect("timeout", function_to_call)
	timer.start()


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
	#audio_player.stream = load("res://Art/Audio/" + missions[current_mission_index]["goal"] + "_demo.mp3")
	#audio_player.play()
	
	dialog_player.show_text(demo_text, 8)
	create_event_timer(2, send_tutor_to_target)
	

### EVENTS ###

func e_initial_greeting() -> void:
	dialog_player.show_text("Hallo!")
	create_event_timer(7, e_show_laptop)
	

func e_show_tutor():
	tutor.visible = true
	audio_player.stream = FINGERPLOP
	audio_player.play()
	create_event_timer(1, e_initial_greeting)

func e_show_laptop():
	objects.visible = true
	audio_player.play()
	create_event_timer(4, start_current_mission)

func send_tutor_to_target():
	tutor.set_target(current_goal_object)

func start_mission_task():
	print("starting task")
	var mission_text = "Geh " + current_goal_object.sentence_block + "! ([A] [D])"
	audio_player.stream = load("res://Art/Audio/" + missions[current_mission_index]["goal"] + "_task.mp3")
	audio_player.play()
	dialog_player.show_text(mission_text, 0)
	target_hot = true


func _on_player_reached_potential_goal(goal):
	if target_hot:
		if goal.id == current_goal_object.id:
			target_hot = false
			audio_player.stream = WIN_JINGLE
			audio_player.play()


func _on_tutor_reached_target():
	print("tutor reached goal")
	create_event_timer(3, start_mission_task)
