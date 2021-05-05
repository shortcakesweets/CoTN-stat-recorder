extends Node2D

onready var control = get_node("Control")
var isUseDivision : bool

func _ready():
	#sync_screen_size()
	pass

func _on_CheckButton_toggled(button_pressed):
	isUseDivision = button_pressed
	
	print(isUseDivision)

func _on_return_button_pressed():
	get_tree().change_scene("res://CoTN_mainscene.tscn")

func sync_screen_size():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	
	control.margin_right = width
	control.margin_bottom = height
