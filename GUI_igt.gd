extends HBoxContainer

signal give_igt(time)

onready var GUI_minute = get_node("minute")
onready var GUI_second = get_node("second")
onready var GUI_ms = get_node("ms")

func _ready():
	pass

func _set_igt_to_rta( time : float ) :
	var ms : int = fmod(time, 1) * 1000
	var second : int = fmod(time,60)
	var minute : int = fmod(time, 3600) / 60
	
	# Debug
	# print(time, minute, second, ms)
	
	GUI_ms.text = str(ms)
	GUI_second.text = str(second)
	GUI_minute.text = str(minute)

func check_valid_text(target_text) -> bool:
	# Debug
	#print(" original : " + target_text)
	# return false when target_text is invalid
	return true

func calculate_time_with_text() -> float :
	var time : float = 0
	
	var ms : float
	var second : int
	var minute : int
	
	if check_valid_text(GUI_ms.text) && check_valid_text(GUI_second.text) && check_valid_text(GUI_minute.text) :
		ms = float(GUI_ms.text)
		second = int(GUI_second.text)
		minute = int(GUI_minute.text)
		
		time = ms/1000 + second + minute*60
	
	# calculate time with them
	# time = ms + second * 100 + minute * 6000
	
	return time

func _text_entered(new_text):
	if not check_valid_text(new_text) :
		return
	
	var time : int = calculate_time_with_text()
	
	emit_signal("give_igt", time)
