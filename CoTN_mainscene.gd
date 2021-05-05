extends Node2D

onready var control = get_node("Control")

func _ready():
	sync_screen_size()

func sync_screen_size():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	control.margin_right = width
	control.margin_bottom = height

func _on_settings_pressed():
	get_tree().change_scene("res://Settings.tscn")

func _on_run_random_seed_pressed():
	get_tree().change_scene("res://Record_Crypt.tscn")
