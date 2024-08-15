extends Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	animation_player.play("react_to_win")

func stop_sound():
	audio_stream_player_2d.stop()

func create_event_timer(n, function_to_call):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = n
	timer.one_shot = true
	timer.connect("timeout", function_to_call)
	timer.start()
