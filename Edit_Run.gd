extends Node2D

enum {LEFT, RIGHT}
onready var camera = get_node("Camera2D")

var crypt_raw : Crypt

func _ready():
	crypt_raw = LocalCryptSave.get_latest_crypt_from_array()
	sync_screen_size()
	_clear_run()
	print_build_in_sentence()
	
	set_GUI_from_data(crypt_raw)
	

func sync_screen_size():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	left_control.margin_right = width
	left_control.margin_bottom = height
	
	right_control.margin_left = width
	right_control.margin_right = width * 2
	right_control.margin_bottom = height

func _clear_run() -> void:
	button_normal.pressed = true
	#crypt_raw.Mod = Crypt.NORMAL
	button_condor.pressed = false
	
	GUI_igt._set_igt_to_rta(0)

func set_GUI_from_data(target_crypt : Crypt) -> void:
	# set character
	label_seed.text = "seed\n%d" % target_crypt.random_seed
	
	var time = target_crypt.rta
	
	var ms = fmod(time, 1) * 1000
	var seconds = fmod(time,60)
	var minutes = fmod(time, 3600) / 60
	var str_elapsed = "%02d:%02d.%03d" % [minutes, seconds, ms]
	
	label_rta.text = "rta\n" + str_elapsed
		
	GUI_igt._set_igt_to_rta(target_crypt.rta)
	
	return

func move_camera(move_to : int, tween_duration = 0.3) -> void:
	var tween = camera.get_node("Tween")
	
	var init_pos : Vector2
	var final_pos : Vector2
	
	if move_to == LEFT : 
		init_pos = Vector2(get_viewport().size.x, 0)
		final_pos = Vector2.ZERO
	elif move_to == RIGHT :
		init_pos = Vector2.ZERO
		final_pos = Vector2(get_viewport().size.x, 0)
	else :
		return
	
	tween.interpolate_property(camera, "position", init_pos, final_pos, tween_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	
	#tween.free()
	
	pass

###########################################
########### Control 1 implement ###########
###########################################

onready var left_control = get_node("Control")

onready var label_seed = get_node("Control/seed")
onready var label_rta = get_node("Control/rta")

onready var GUI_igt = get_node("Control/igt")

onready var button_normal = get_node("Control/normal")
onready var button_condor = get_node("Control/condor")

onready var GUI_death = get_node("Control/death")

func _on_normal_toggled(button_pressed):
	button_condor.pressed = !button_pressed
	crypt_raw.Mod = Crypt.NORMAL

func _on_condor_toggled(button_pressed):
	button_normal.pressed = !button_pressed
	crypt_raw.Mod = Crypt.CoNDOR

func _on_death_item_selected(index):
	crypt_raw.death = GUI_death.get_item_text(index)
	print(crypt_raw.death)

func _on_igt_give_igt(time):
	print(" Edit run got a time of " + str(time))
	
	crypt_raw.igt = time
	#print(crypt_raw.rta)
	#print(time)

func _on_next_page_pressed():
	move_camera(RIGHT)

###########################################
########### Control 2 implement ###########
###########################################

onready var right_control = get_node("Control2")

onready var GUI_build_maker = get_node("Control2/build_maker")
onready var GUI_build_item = get_node("Control2/build_maker/item")
onready var GUI_build_floor = get_node("Control2/build_maker/floor")
onready var GUI_build_how = get_node("Control2/build_maker/how")

onready var GUI_view_item = get_node("Control2/view_item")
onready var GUI_view_floor = get_node("Control2/view_floor")
onready var GUI_view_floor_label = get_node("Control2/view_floor/view_floor_label")
onready var GUI_view_how = get_node("Control2/view_how")

onready var GUI_label_showing_build = get_node("Control2/add_to_build/added_build_label")

var build_raw : Crypt.Build = Crypt.Build.new()

func _on_prev_page_pressed():
	move_camera(LEFT)

func parse_build(build):
	var temp = []
	for i in range(0,len(build)):
		temp.append({
			"item" : build[i].item,
			"where" : build[i].where,
			"how" : build[i].how
		})
	return temp
	
func _on_post_pressed():
	cook_crypt_from_GUI()
	
	print("POST RESULT")
	print(crypt_raw)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
	var body = {"nick": crypt_raw.player_name, "character": crypt_raw.Character, "mode": crypt_raw.Mod, "igt":crypt_raw.igt, "rta":crypt_raw.rta, "random_seed":crypt_raw.random_seed, "death":crypt_raw.death, "isWin":crypt_raw.isWin, "build":parse_build(crypt_raw.build)}
	var error = http_request.request("http://3.35.91.222:4500/api/data", ["Content-Type: application/json"], true, HTTPClient.METHOD_POST, to_json(body))
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func cook_crypt_from_GUI() -> void:
	# Mod, igt, rta, random_seed, death, build are already cooked automatically
	# however because of consistency reasons, igt is cooked twice :(
	
	# need to cook player_name(nick), igt
	
	########## cook igt #############
	# force igt to think text is entered again
	#GUI_igt._text_entered()
	#################################
	
	########## cook isWin ###########
	if( crypt_raw.death == "WIN!" ) :
		crypt_raw.isWin = true
	else :
		crypt_raw.isWin = false
	#################################
	
	return



func _on_item_item_selected(index):
	build_raw.item_texture = GUI_build_item.get_item_icon(index)
	GUI_view_item.texture = build_raw.item_texture
	
	build_raw.item = index

func _on_floor_item_selected(index):
	build_raw.where_texture = GUI_build_floor.get_item_icon(index)
	GUI_view_floor.texture = build_raw.where_texture
	GUI_view_floor_label.text = GUI_build_floor.get_item_text(index)
	
	build_raw.where = GUI_build_floor.get_item_text(index)

func _on_how_item_selected(index):
	build_raw.how_texture = GUI_build_how.get_item_icon(index)
	GUI_view_how.texture = build_raw.how_texture
	
	build_raw.how = index

func _on_add_to_build_pressed() -> void:
	# DEBUG (print current build_raw)
	print( build_raw.item )
	print( build_raw.where)
	print( build_raw.how  )
	print("\n")
	
	# check if build has build_raw already. This can be modified to make build editing GUI
	for existing_build in crypt_raw.build :
		if existing_build.item == build_raw.item :
			print(" Alreay existing item! ")
			
			# Edit build's where & how
			existing_build.where = build_raw.where
			existing_build.how = build_raw.how
			
			# renew sentences
			print_build_in_sentence()
			
			return
	
	# make a new build in crypt_raw and duplicate build_raw's properties
	crypt_raw.build.append( Crypt.Build.new() )
	
	var last_index : int = crypt_raw.build.size() - 1
	if last_index < 0 :
		print(" something happend... ") # line210 crypt_raw_build.append() failed
		return
	
	crypt_raw.build[ last_index ].item = build_raw.item
	crypt_raw.build[ last_index ].where = build_raw.where
	crypt_raw.build[ last_index ].how = build_raw.how
	
	
	# Print builds in words!
	print_build_in_sentence()
	
	return

func _on_delete_build_pressed():
	crypt_raw.build.pop_back()
	
	print_build_in_sentence()

func print_build_in_sentence() -> void:
	var sentence : String = ""
	var full_sentence : String = ""
	
	for existing_build in crypt_raw.build :
		sentence = ""
		
		sentence = GUI_build_item.item_find_text_by_index( existing_build.item ) 
		sentence += " in "
		sentence += existing_build.where
		sentence += " from "
		sentence += GUI_build_how.how_find_text_by_index( existing_build.how )
		sentence += "\n"
		
		# Debug
		print( sentence )
		#
		
		full_sentence += sentence
		
	GUI_label_showing_build.text = full_sentence

func _on_return_pressed():
	# Print a caution message
	
	get_tree().change_scene("res://CoTN_mainscene.tscn")




