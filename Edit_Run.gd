extends Node2D

onready var GUI_igt = get_node("Control/igt")
onready var button_normal = get_node("Control/normal")
onready var button_condor = get_node("Control/condor")

onready var GUI_death = get_node("Control/death")

onready var GUI_build_maker = get_node("Control2/build_maker")

var crypt_raw : Crypt

func _ready():
	_clear_run()
	
	crypt_raw = Crypt.new()

func _clear_run() :
	button_normal.pressed = true
	button_condor.pressed = false
	
	GUI_igt._set_igt_to_rta(0)

func _on_normal_toggled(button_pressed):
	button_condor.pressed = !button_pressed

func _on_condor_toggled(button_pressed):
	button_normal.pressed = !button_pressed

func _on_death_item_selected(index):
	crypt_raw.death = GUI_death.get_item_text(index)
	print(crypt_raw.death)

func _on_igt_give_igt(time):
	crypt_raw.igt = time
	print(time)
