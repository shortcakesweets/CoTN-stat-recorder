extends Node2D

enum {LEFT, MIDDLE, RIGHT}
enum {Cadence, Melody, Aria, Dorian, Eli, Monk, Dove, Coda, Bolt, Bard, Nocturna, Diamond, Mary, Tempo, Reaper}
onready var camera = get_node("Camera2D")

onready var font_maximum : DynamicFont = load("res://necrosans/font_maximum.tres")
onready var font_large : DynamicFont = load("res://necrosans/font_large.tres")
onready var font_medium : DynamicFont = load("res://necrosans/font_medium.tres")
onready var font_small : DynamicFont = load("res://necrosans/font_small.tres")
# onready var font_minimum : DynamicFont = load("res://necrosans/font_minimum.tres")

func _ready():
	# Control 1 _ready
	GUI_player_name.text = LocalCryptSave.username
	GUI_character_list.select(Cadence)
	
	pass

func sync_screen_size():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	left_control.margin_right = width
	left_control.margin_bottom = height
	
	middle_control.margin_left = width
	middle_control.margin_right = width * 2
	middle_control.margin_bottom = height
	
	right_control.margin_left = width * 2
	right_control.margin_right = width * 3
	right_control.margin_bottom = height
	
	# Icon scales
	var custom_scale : float = float(width / 750.0) * 2.0
	
	GUI_character_list.icon_scale = custom_scale

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


func move_camera(move_to : int, tween_duration = 0.3) -> void:
	var tween = camera.get_node("Tween")
	
	var init_pos : Vector2
	var final_pos : Vector2
	
	if move_to == LEFT : 
		init_pos = Vector2(get_viewport().size.x, 0)
		final_pos = Vector2.ZERO
	elif move_to == RIGHT :
		init_pos = Vector2(get_viewport().size.x, 0)
		final_pos = Vector2(2 * get_viewport().size.x, 0)
	elif move_to == MIDDLE :
		init_pos = camera.position
		final_pos = Vector2(get_viewport().size.x, 0)
	else :
		return
	
	tween.interpolate_property(camera, "position", init_pos, final_pos, tween_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	
	#tween.free()
	
	pass

func _on_return_pressed():
	get_tree().change_scene("res://CoTN_mainscene.tscn")

###############################################
############## Control 1 implement ############
###############################################

onready var left_control = get_node("Control")

var search_option : Array = ["Anonymous", Crypt.NORMAL, Cadence]

onready var GUI_player_name = get_node("Control/player_name")
onready var button_normal = get_node("Control/normal")
onready var button_condor = get_node("Control/condor")
onready var GUI_character_list = get_node("Control/character_list")

onready var button_search = get_node("Control/search")
onready var button_detail = get_node("Control/detail")

func _on_normal_toggled(button_pressed):
	button_condor.pressed = !button_pressed

func _on_condor_toggled(button_pressed):
	button_normal.pressed = !button_pressed

func _on_detail_pressed():
	move_camera(MIDDLE)

func _on_search_pressed():
	button_detail.disabled = false
	button_search.disabled = true
	
	# Renew search_option
	search_option.clear()
	search_option.append(GUI_player_name.text)
	if button_normal.pressed :
		search_option.append(Crypt.NORMAL)
	else :
		search_option.append(Crypt.CoNDOR)
	
	if _get_character_on_GUI() != -1 :
		search_option.append( _get_character_on_GUI() )
	else :
		search_option.append(1) # Default cadence
	
	# Get player informations from server
	
	return

func _renew_buttons(_button_toggled) -> void:
	print(" _renew_buttons_triggered ")
	button_detail.disabled = _is_option_changed()
	button_search.disabled = !_is_option_changed()

func _is_option_changed() -> bool:
	var new_search_option : Array = []
	
	new_search_option.append(GUI_player_name.text)
	if button_normal.pressed :
		new_search_option.append(Crypt.NORMAL)
	else :
		new_search_option.append(Crypt.CoNDOR)
	
	if _get_character_on_GUI() != -1 :
		new_search_option.append( _get_character_on_GUI() )
	else :
		return true
	
	if new_search_option == search_option :
		return false
	else :
		return true

func _get_character_on_GUI() -> int:
	for idx in GUI_character_list.get_item_count() :
		if GUI_character_list.is_selected(idx) :
			return idx
	
	return -1

###############################################
############## Control 2 implement ############
###############################################

onready var middle_control = get_node("Control2")



###############################################
############## Control 3 implement ############
###############################################

onready var right_control = get_node("Control3")
