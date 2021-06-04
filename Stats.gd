extends Node2D

enum {LEFT, MIDDLE, RIGHT}
enum {Cadence, Melody, Aria, Dorian, Eli, Monk, Dove, Coda, Bolt, Bard, Nocturna, Diamond, Mary, Tempo, Reaper}
onready var camera = get_node("Camera2D")

onready var http_request = get_node("HTTPRequest")

onready var font_maximum : DynamicFont = load("res://necrosans/font_maximum.tres")
onready var font_large : DynamicFont = load("res://necrosans/font_large.tres")
onready var font_medium : DynamicFont = load("res://necrosans/font_medium.tres")
onready var font_small : DynamicFont = load("res://necrosans/font_small.tres")
# onready var font_minimum : DynamicFont = load("res://necrosans/font_minimum.tres")

var searched_crypt : Array = []
var JSON_parsed_searched_crypt : JSONParseResult

func _ready():
	# Control 1 _ready
	GUI_player_name.text = LocalCryptSave.username
	GUI_character_list.select(Cadence)
	
	simple_stats.text = ""
	
	sync_screen_size()
	sync_text_size()
	
	# Control 2 _ready
	for block in GUI_crypt_list.get_children() : # Resize GUI
		block._ready()
	
	# Control 3 _ready
	summary_block._ready()
	
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

onready var simple_stats = get_node("Control/simple_stats")

func _on_normal_toggled(button_pressed):
	button_condor.pressed = !button_pressed

func _on_condor_toggled(button_pressed):
	button_normal.pressed = !button_pressed

func _on_detail_pressed():
	# Control2
	_set_control2_init()
	
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
		search_option.append(0) # Default cadence
	
	# (on control2)
	#_set_search_option_label()
	
	# Get player informations from server
	var basic_adress : String = "http://3.35.91.222:4500/api/data"
	
	# http://3.35.91.222:4500/api/data?character=0&mode=0&nick=shortcakesweets
	http_request.request(basic_adress + "?character=" + str(search_option[2]) + "&mode=" + str(search_option[1]) + "&nick=" + search_option[0])
	
	return

# Helper function on server communications
func _on_HTTPRequest_request_completed(_result, _response_code, _headers, body):
	searched_crypt.clear()
	if parse_json(body.get_string_from_utf8()) != null :
		searched_crypt = parse_json(body.get_string_from_utf8())
	
#	if JSON.parse( body.get_string_from_utf8() ) != null :
#		JSON_parsed_searched_crypt = JSON.parse( body.get_string_from_utf8() )
#
	
	# Debug
	for not_parsed_crypt in searched_crypt :
		print(not_parsed_crypt)
		print("\n")
		
		# not_parsed_crypt is a type "Dictionary"
	
	_show_simple_stats()

func _show_simple_stats() -> void:
	var total_runs : int = searched_crypt.size()
	if total_runs == 0 :
		simple_stats.text = "cannot find stats matching that information"
		button_search.disabled = false
		button_detail.disabled = true
		return
	
	var cleared_runs : int = 0
	
	var all_rta : Array = []
	var all_igt : Array = []
	
	for data in searched_crypt :
		if data["isWin"] == true :
			cleared_runs += 1
			
			all_rta.append(data["rta"])
			all_igt.append(data["igt"])
	
	var clear_rate : float = float(cleared_runs) / total_runs * 100.0
	# Debug
	#print(all_rta)
	#print(all_igt)
	
	var stats_rta = _get_average_and_std(all_rta)
	var stats_igt = _get_average_and_std(all_igt)
	
	var stat_line : Array = []
	
	stat_line.append("total runs (clears) : %d (%d)\n" % [total_runs, cleared_runs])
	stat_line.append("\n")
	stat_line.append("clear rate : %.2f\n" % clear_rate)
	stat_line.append("\n")
	stat_line.append("Average rta : " + _convert_time_to_string(stats_rta[0]) )
	stat_line.append("\n")
	stat_line.append("std : " + _convert_time_to_string(stats_rta[1]) )
	stat_line.append("\n\n")
	stat_line.append("Average igt : " + _convert_time_to_string(stats_igt[0]) )
	stat_line.append("\n")
	stat_line.append("std : " + _convert_time_to_string(stats_igt[1]) )
	
	simple_stats.text = ""
	for line in stat_line :
		simple_stats.text += line
	
	return 

# Helper function of statistics.
func _get_average_and_std(data : Array) -> Array :
	if data.size() == 0:
		return [0,0]
	
	var avg : float = 0.0
	var avg_square : float = 0.0
	var std : float = 0.0
	
	for x in data :
		if typeof(x) != TYPE_REAL :
			x = float(x)
			print(x)
		
		avg += x
		avg_square += x * x
	
	avg = avg / data.size()
	avg_square = avg_square / data.size()
	
	std = sqrt( avg_square - avg * avg )
	
	return [avg, std]

# Helper function to visualize time(float)
func _convert_time_to_string(time : float) -> String :
	var ms = fmod(time, 1) * 1000
	var seconds = fmod(time,60)
	var minutes = fmod(time, 3600) / 60
	var str_elapsed = "%02d:%02d.%02d" % [minutes, seconds, ms]
	
	return str_elapsed

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

var curr_page : int = 1
var total_page : int

onready var middle_control = get_node("Control2")
onready var label_search_option = get_node("Control2/search_option_label2")
onready var GUI_crypt_list = get_node("Control2/crypt_list")
onready var GUI_current_page = get_node("Control2/current_page")

# Change this later
func _set_search_option_label() -> void:
	# var search_option : Array = ["Anonymous", Crypt.NORMAL, Cadence]
	
	label_search_option.text = ""
	label_search_option.text += "player : " + search_option[0]
	label_search_option.text += "\n"
	label_search_option.text += "character : " + "Cadence"
	label_search_option.text += "\n"
	label_search_option.text += "mod : " + "Normal"
	
	pass

func _set_control2_init() -> void:
	_set_search_option_label()
	
	curr_page = 1
	write_page(curr_page)
	
	var total_crypt_num : int = searched_crypt.size()
	total_page = ceil( float(total_crypt_num) / 3.0 )
	
	return

func write_page(page_idx : int) -> void:
	var block_1 = get_node("Control2/crypt_list/Crypt_block1")
	var block_2 = get_node("Control2/crypt_list/Crypt_block2")
	var block_3 = get_node("Control2/crypt_list/Crypt_block3")
	
	var block_array = [block_1, block_2, block_3]
	
	for i in range(3) :
		if block_array[i] == null :
			print(" Error : Block not detected ")
			return
		
		var block = block_array[i]
		
		if (page_idx - 1) * 3 + i >= searched_crypt.size() :
			block.set_data() # set to null data
		else :
			var target_crypt : Dictionary = searched_crypt[(page_idx - 1) * 3 + i]
			
#			block.set_death(target_crypt["death"])
#			block.set_runtime(float(target_crypt["rta"]), float(target_crypt["igt"]))
#			block.set_build( parse_json(target_crypt["build"]) )
			
			block.set_data(target_crypt["death"], float(target_crypt["rta"]), float(target_crypt["igt"]), parse_json(target_crypt["build"]) )
	
	GUI_current_page.text = str(curr_page)
	
	
	pass

func _on_page_changer_pressed(delta : int):
	# p_prev : -5
	# prev : -1
	# next : 1
	# n_next : 5
	
	curr_page += delta
	
	if curr_page <= 0 :
		curr_page = 1
	elif curr_page > total_page :
		curr_page = total_page
	
	write_page(curr_page)
	
	return

func _on_prev_page_pressed(idx):
	move_camera(idx)

func _on_crypt_block_touch_detected(idx) -> void:
	# detect oob and ignore detection prior.
	if (curr_page - 1) * 3 + idx >= searched_crypt.size() : #OOB
		return
	
	var target_crypt : Dictionary = searched_crypt[(curr_page - 1) * 3 + idx]
	write_summary_crypt_block(target_crypt)
	
	move_camera(RIGHT) # Goto last page
	
	return

###############################################
############## Control 3 implement ############
###############################################

onready var right_control = get_node("Control3")
onready var label_seed = get_node("Control3/seed")
onready var label_comments = get_node("Control3/comments")

onready var summary_block = get_node("Control3/semi_control/summary_block")

# still implementing.

func write_summary_crypt_block(target_crypt : Dictionary) -> void :
	
	var build = parse_json(target_crypt["build"])
	summary_block.set_data(target_crypt["death"], float(target_crypt["rta"]), float(target_crypt["igt"]), build )
	
	label_seed.text = "seed : " + str(target_crypt["random_seed"])
	
	for raw_sentence in build :
		pass # Implement later
	
	return

func _on_summary_block_touch_detected():
	LocalCryptSave.save_seed( int(label_seed.text) )
	get_tree().change_scene("res://Record_Crypt.tscn")
	
	pass

