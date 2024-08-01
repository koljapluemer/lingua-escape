extends CanvasLayer

var active_text = []

@onready var background = %Background
@onready var text_label = %TextLabel
@onready var box: HBoxContainer = %Box

func _ready():
	background.visible = false
	box.visible = false

func show_text(text):
	text_label.text = text
	background.visible = true
	box.visible = true


func finish():
	text_label.text = ""
	background.visible = false	
	box.visible = false
