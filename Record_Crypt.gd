extends Node2D

signal post_run(crypt)

var rng = RandomNumberGenerator.new()

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


var time = 0
var isTimerOn : bool = false
var run_prepost : Crypt = Crypt.new()

func sync_screen_size():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	
	control.margin_right = width
	control.margin_bottom = height

func _ready():
	
	sync_screen_size()
	_reset_timer()
	five_second_timer.visible = false
	
	#button_post.disabled = !isTimerOn
	#button_discard.disabled = !isTimerOn

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
	
	run_prepost.random_seed = rng.randi_range(10000, 99999999)
	label_seed.text = "Seeded Run\n%d" % run_prepost.random_seed
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
