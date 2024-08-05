extends Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var purr_label: Label = %PurrLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	purr_label.visible = false	
	start_purring()


func start_purring():
	purr_label.visible = true	
	animation_player.play("purr")	
	create_event_timer(2, stop_purring)
	
func stop_purring():
	animation_player.stop()
	purr_label.visible = false	
	
	#audio_stream_player_2d.stop()

func create_event_timer(n, function_to_call):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = n
	timer.one_shot = true
	timer.connect("timeout", function_to_call)
	timer.start()
