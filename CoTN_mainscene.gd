extends Node2D

onready var control = get_node("Control")

func _ready():
	sync_screen_size()
	# sync_text_size() >> not done

func sync_screen_size():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	control.margin_right = width
	control.margin_bottom = height

func sync_text_size():
	# Text size varies by resolution
	#   minimum : x1 (don't use this size)
	#   small : x2
	#   medium : x3
	#   big : x4
	#   maximum : x5.5
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
	
	var text_minimum : Array = get_tree().get_nodes_in_group("text_minimum")
	var text_small : Array = get_tree().get_nodes_in_group("text_small")
	var text_medium : Array = get_tree().get_nodes_in_group("text_medium")
	var text_large : Array = get_tree().get_nodes_in_group("text_large")
	var text_maximum : Array = get_tree().get_nodes_in_group("text_maximum")
	
	for target_node in text_minimum :
		set_text_size_of_node(target_node, text_size)
	
	for target_node in text_small :
		# Debug
		print(target_node)
		set_text_size_of_node(target_node, text_size * 2)
	
	for target_node in text_medium :
		# Debug
		print(target_node)
		set_text_size_of_node(target_node, text_size * 3)
	
	for target_node in text_large :
		# Debug
		print(target_node)
		set_text_size_of_node(target_node, text_size * 4)
	
	for target_node in text_maximum :
		set_text_size_of_node(target_node, text_size * 6)
	
func set_text_size_of_node(target_node, text_size : int) :
	# check target_node is actually a node >> pass
	
	# check target_node has property custom_fonts/fonts
	
	if "Control" in target_node :
		# target_node has property "custom_fonts/font"
		print("access success on :")
		print(target_node)
		
		target_node.Control.custum_fonts.size = text_size


func _on_settings_pressed():
	get_tree().change_scene("res://Settings.tscn")

func _on_run_random_seed_pressed():
	get_tree().change_scene("res://Record_Crypt.tscn")
