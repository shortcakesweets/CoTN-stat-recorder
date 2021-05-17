extends Node2D

#signal post_run(crypt)

var rng = RandomNumberGenerator.new()

onready var font_maximum : DynamicFont = load("res://necrosans/font_maximum.tres")
onready var font_large : DynamicFont = load("res://necrosans/font_large.tres")
onready var font_medium : DynamicFont = load("res://necrosans/font_medium.tres")
onready var font_small : DynamicFont = load("res://necrosans/font_small.tres")
# onready var font_minimum : DynamicFont = load("res://necrosans/font_minimum.tres")

onready var label_timer = get_node("Control/Label_Timer")
onready var label_seed = get_node("Control/Label_Seed")
onready var label_settings = get_node("Control/Label_Settings")

onready var button_post = get_node("Control/Label_Timer/Button_Post")
onready var button_discard = get_node("Control/Label_Timer/Button_Discard")
onready var button_start = get_node("Control/Label_Timer/start_timer")
onready var button_random_seed = get_node("Control/Label_Seed/random_seed")

onready var animated_sprite = get_node("Control/AnimatedSprite")

onready var control = get_node("Control")

onready var five_second_timer = get_node("Five_Second_Timer")


var time : float = 0
var isTimerOn : bool = false
var crypt_raw : Crypt = Crypt.new()

func sync_screen_size():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	
	control.margin_right = width
	control.margin_bottom = height
	
	animated_sprite.position = Vector2(width, height) * 0.15
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

func _ready():
	
	sync_screen_size()
	sync_text_size()
	_reset_timer()
	five_second_timer.visible = false
	
	_on_random_seed_pressed()
	
	#button_post.disabled = !isTimerOn
	#button_discard.disabled = !isTimerOn

func get_data_from_GUI() -> void :
	# get character data from GUI
	
	crypt_raw.rta = time
	
	# Random seed is automatically recorded
	
	return
	

func _count_five_seconds():
	five_second_timer._start_timer()
	
	var timer = Timer.new()
	timer.wait_time = 5
	
	timer.start()
	
	yield(timer, "timeout")

func _start_timer():
	#_count_five_seconds()
	
	isTimerOn = true
	change_timerButton_state(!isTimerOn)
	
	button_random_seed.disabled = true

func _reset_timer():
	time = 0
	isTimerOn = false
	
	var str_elapsed = "00:00.000"
	label_timer.text = str_elapsed
	
	change_timerButton_state(!isTimerOn)

func _process(delta):
	button_post.disabled = isTimerOn
	button_discard.disabled = isTimerOn
	
	if not isTimerOn :
		return
	
	time += delta
	var ms = fmod(time, 1) * 1000
	var seconds = fmod(time,60)
	var minutes = fmod(time, 3600) / 60
	var str_elapsed = "%02d:%02d.%03d" % [minutes, seconds, ms]
	
	label_timer.text = str_elapsed

func _on_Button_Discard_pressed():
	_reset_timer()

func _input(event):
	if event is InputEventMouseButton :
		if event.doubleclick : 
			print('double click', event)
			#isTimerOn = !isTimerOn
			isTimerOn = false
			change_timerButton_state(!isTimerOn)
		else :
			#print('single click', event)
			pass

func _on_random_seed_pressed():
	rng.randomize()
	
	crypt_raw.random_seed = rng.randi_range(10000, 99999999)
	label_seed.text = "Seeded Run\n%d" % crypt_raw.random_seed
	pass

func change_timerButton_state(isPause) :
	button_start.disabled = !isPause
	#button_start.visible = isPause
	
	button_post.disabled = isPause
	#button_post.visible = !isPause
	
	button_discard.disabled = isPause
	#button_discard.visible = !isPause
	
	animated_sprite.playing = !isPause
	
	if time != 0:
		button_start.text = "Resume run"
		button_random_seed.disabled = true
	else :
		button_start.text = "Start run"
		button_random_seed.disabled = false

func _on_start_timer_pressed():
	_start_timer()

func _on_Button_Return_pressed():
	get_tree().change_scene("res://CoTN_mainscene.tscn")

func _on_Button_Post_pressed():
	get_data_from_GUI()
	LocalCryptSave.push_crypt_to_array(crypt_raw)
	
	# Debug
	print(LocalCryptSave.crypt_slot)
	
	get_tree().change_scene("res://Edit_Run.tscn")
