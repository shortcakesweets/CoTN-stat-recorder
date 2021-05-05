extends Node2D

signal post_run(crypt)

onready var touchscreen = $TouchScreen
onready var label_timer = $Label_Timer
onready var label_seed = $Label_Seed
onready var label_settings = $Label_Settings

onready var button_post = $Label_Timer/Button_Post
onready var button_discard = $Label_Timer/Button_Discard

onready var animated_sprite = $AnimatedSprite

var time = 0
var isTimerOn : bool = false

func _ready():
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	
	print( width, height )
	
	# animated_sprite positioning on screen
	#var offset : Vector2 = Vector2( width / 30 , height / 30 )
	#var text_size_offset : int = 64
	
	#animated_sprite.position = Vector2( width * 0.125 , width * 0.125 ) + offset
	#animated_sprite.scale = Vector2( width / 250 , width / 250 )
	
	# label_seed positioning on screen
	#label_seed.margin_left = width * (2/3) - offset.x
	#label_seed.margin_right = width - offset.x
	
	#label_seed.margin_top = offset.y
	#label_seed.margin_bottom = offset.y + width * (1/5)
	
	
	time = 0
	isTimerOn = false
	animated_sprite.playing = false
	
	#_start_timer()






func _count_five_seconds():
	pass

func _start_timer():
	isTimerOn = true

func _reset_timer():
	time = 0
	isTimerOn = false

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

func _on_TouchScreen_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton :
		if event.doubleclick :
			print('double click ', event)
			isTimerOn = !isTimerOn
			animated_sprite.playing = isTimerOn
		else :
			#print('single click', event)
			pass


func _on_Button_Discard_pressed():
	_reset_timer()
