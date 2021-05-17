extends Node2D

onready var control = get_node("Control")

var font_size = 12

onready var font_maximum : DynamicFont = load("res://necrosans/font_maximum.tres")
onready var font_large : DynamicFont = load("res://necrosans/font_large.tres")
onready var font_medium : DynamicFont = load("res://necrosans/font_medium.tres")
onready var font_small : DynamicFont = load("res://necrosans/font_small.tres")
# onready var font_minimum : DynamicFont = load("res://necrosans/font_minimum.tres")

onready var button_small = get_node("Control/fontsize_small")
onready var button_medium = get_node("Control/fontsize_medium")
onready var button_large = get_node("Control/fontsize_large")

onready var debug_font_size = get_node("Control/Debug_label_font_size")

onready var GUI_username = get_node("Control/username")

func _ready():
	sync_screen_size()
	
	font_size = 12
	
	sync_text_size()
	
	GUI_username.text = LocalCryptSave.username

func sync_text_size() -> void:
	# Text size varies by resolution
	#   minimum : x1 (don't use this size)
	#   small : x2
	#   medium : x3
	#   big : x4
	#   maximum : x6
	#
	# on 750 * 1330 androids, we use x1 as 12 pixels.
	#  (small : 24px, maximum : 76px)
	
	var text_size = LocalCryptSave.font_size
	
	#var width = get_viewport().size.x
	# var height = get_viewport().size.y
	
	font_maximum.size = text_size * 6
	font_large.size = text_size * 4
	font_medium.size = text_size * 3
	font_small.size = text_size * 2
	# font_minimum.size = text_size * 1
	
	var GROUP_font_maximum = get_tree().get_nodes_in_group("font_maximum")
	var GROUP_font_large = get_tree().get_nodes_in_group("font_large")
	var GROUP_font_medium = get_tree().get_nodes_in_group("font_medium")
	var GROUP_font_small = get_tree().get_nodes_in_group("font_small")
	# var GROUP_font_minimum = get_tree().get_nodes_in_group("font_minimum")
	
	for target_node in GROUP_font_maximum :
		if "custom_fonts/font" in target_node :
			target_node.set("custom_fonts/font", font_maximum)
	
	for target_node in GROUP_font_large :
		if "custom_fonts/font" in target_node :
			target_node.set("custom_fonts/font", font_large)
	
	for target_node in GROUP_font_medium :
		if "custom_fonts/font" in target_node :
			target_node.set("custom_fonts/font", font_medium)
	
	for target_node in GROUP_font_small :
		if "custom_fonts/font" in target_node :
			target_node.set("custom_fonts/font", font_small)
	
	# Skip minimum nodes.
	
	return

func _on_return_button_pressed():
	LocalCryptSave.username = GUI_username.text
	LocalCryptSave.font_size = font_size
	LocalCryptSave.save_userdata()
	
	get_tree().change_scene("res://CoTN_mainscene.tscn")

func sync_screen_size():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	
	control.margin_right = width
	control.margin_bottom = height

func _on_fontsize_button_pressed(new_font_size : int) :
	font_size = new_font_size 
	LocalCryptSave.font_size = new_font_size
	
	debug_font_size.text = "current font size is set to\n(minimum) "+ str(new_font_size)
	
	sync_text_size()
