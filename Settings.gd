extends Node2D

onready var control = get_node("Control")
var isUseDivision : bool

onready var font_maximum : DynamicFont = load("res://necrosans/font_maximum.tres")
onready var font_large : DynamicFont = load("res://necrosans/font_large.tres")
onready var font_medium : DynamicFont = load("res://necrosans/font_medium.tres")
onready var font_small : DynamicFont = load("res://necrosans/font_small.tres")
# onready var font_minimum : DynamicFont = load("res://necrosans/font_minimum.tres")

func _ready():
	sync_screen_size()
	sync_text_size()

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
	
	var text_size : int
	
	var width = get_viewport().size.x
	# var height = get_viewport().size.y
	
	if width >= 700 :
		text_size = 12
		
		if width >= 1400 :
			text_size = 18
			
			if width >= 1600 :
				text_size = 24
				
	# Debug
	$Control/Debug_label_font_size.text = "current font size is set to\n" + "minimum " + str(text_size)
	
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
