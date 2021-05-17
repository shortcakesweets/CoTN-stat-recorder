extends Node2D

onready var control = get_node("Control")

onready var font_maximum : DynamicFont = load("res://necrosans/font_maximum.tres")
onready var font_large : DynamicFont = load("res://necrosans/font_large.tres")
onready var font_medium : DynamicFont = load("res://necrosans/font_medium.tres")
onready var font_small : DynamicFont = load("res://necrosans/font_small.tres")
# onready var font_minimum : DynamicFont = load("res://necrosans/font_minimum.tres")

onready var animated_sprite = get_node("Control/AnimatedSprite")

func _ready():
	# sync_screen_size() will be used every node, and will have it's 
	# own unique methods per node. contains resizing character animation.
	sync_screen_size()
	
	# sync_text_size() will be used every node
	# I know it is least optimized I know; but its a simple app we don't
	#need performance optimizations
	sync_text_size()

func sync_screen_size():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	control.margin_right = width
	control.margin_bottom = height
	
	animated_sprite.position = Vector2( width * 0.2, height * 0.2 )
	animated_sprite.scale = Vector2(1,1) * float(width / 750.0) * 4.0

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


func _on_settings_pressed():
	get_tree().change_scene("res://Settings.tscn")

func _on_run_random_seed_pressed():
	get_tree().change_scene("res://Record_Crypt.tscn")
