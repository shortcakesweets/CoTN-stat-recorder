extends Node2D

enum {LEFT, RIGHT}
onready var camera = get_node("Camera2D")

var crypt_raw : Crypt

func _ready():
	sync_screen_size()
	_clear_run()
	
	crypt_raw = LocalCryptSave.get_latest_crypt_from_array()
	set_GUI_from_data(crypt_raw)
	
	# Debug
	#print(crypt_raw)

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

func _on_condor_toggled(button_pressed):
	button_normal.pressed = !button_pressed

func _on_death_item_selected(index):
	crypt_raw.death = GUI_death.get_item_text(index)
	print(crypt_raw.death)

func _on_igt_give_igt(time):
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

var build_raw : Crypt.Build = Crypt.Build.new()

func _on_prev_page_pressed():
	move_camera(LEFT)

func _on_post_pressed():
	pass # Replace with function body.


func _on_item_item_selected(index):
	build_raw.item_texture = GUI_build_item.get_item_icon(index)
	GUI_view_item.texture = build_raw.item_texture

func _on_floor_item_selected(index):
	build_raw.where_texture = GUI_build_floor.get_item_icon(index)
	GUI_view_floor.texture = build_raw.where_texture
	GUI_view_floor_label.text = GUI_build_floor.get_item_text(index)

func _on_how_item_selected(index):
	build_raw.how_texture = GUI_build_how.get_item_icon(index)
	GUI_view_how.texture = build_raw.how_texture

func _on_return_pressed():
	# Print a caution message
	
	get_tree().change_scene("res://CoTN_mainscene.tscn")
