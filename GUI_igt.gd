extends HBoxContainer

signal give_igt(time)

onready var GUI_minute = get_node("minute")
onready var GUI_second = get_node("second")
onready var GUI_ms = get_node("ms")

func _ready():
	pass

func _set_igt_to_rta( time  : int ) :
	var ms = fmod(time, 1) * 1000
	var second = fmod(time,60)
	var minute = fmod(time, 3600) / 60
	
	GUI_ms.text = str(ms)
	GUI_second.text = str(second)
	GUI_minute.text = str(minute)

func check_valid_text(target_text) -> bool:
	# return false when target_text is invalid
	return true

func calculate_time_with_text() -> int :
	var time : int = 0
	
	var ms = GUI_ms.text
	var second = GUI_second.text
	var minute = GUI_minute.text
	
	# calculate time with them
	# time = ms + second * 100 + minute * 6000
	
	return time

func _text_entered(new_text):
	if not check_valid_text(new_text) :
		return
	
	var time = calculate_time_with_text()
	
	emit_signal("give_igt", time)
