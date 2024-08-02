extends CanvasLayer
signal dialog_finished

var active_text = []

@onready var background = %Background
@onready var text_label = %TextLabel
@onready var box: HBoxContainer = %Box

func _ready():
	background.visible = false
	box.visible = false

func show_text(text, kill_after=5):
	kill_all_timer_children()
	text_label.text = text
	background.visible = true
	box.visible = true
	# 0 kill_after means infinite
	if not kill_after == 0:
		create_kill_timer(kill_after)

func kill_all_timer_children():
	for child in get_children():
		if child is Timer:
			child.queue_free()


func finish():
	text_label.text = ""
	background.visible = false	
	box.visible = false
	emit_signal("dialog_finished")

func create_kill_timer(n):
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = n
	timer.one_shot = true
	timer.connect("timeout", finish)
	timer.start()
