extends Control

onready var checkbox_peace = get_node("CheckBox_Peace")
onready var checkbox_space = get_node("CheckBox_Space")
onready var checkbox_shop = get_node("CheckBox_Shop")

export var varience_data : Array = ["", "", ""]
var array_checkbox : Array = [checkbox_peace, checkbox_space, checkbox_shop]

func _ready() -> void:
	varience_data = ["", "", ""]
	array_checkbox = [checkbox_peace, checkbox_space, checkbox_shop]
	set_varience()
	pass

func set_varience() -> void :
	for i in range(3) :
		if varience_data[i] == "" : # null data
			array_checkbox[i].get_node("LineEdit").text = "0-0"
			array_checkbox[i].get_node("LineEdit").editable = false
		else :
			array_checkbox[i].get_node("LineEdit").text = varience_data[i]
			array_checkbox[i].get_node("LineEdit").editable = true
			array_checkbox[i].pressed = true

func get_varience() -> void :
	for i in range(3) :
		varience_data[i] = array_checkbox[i].get_node("LineEdit").text

func force_readmode(readmode : bool) -> void :
	set_varience()
	
	for i in range(3) :
		array_checkbox[i].disabled = readmode
		array_checkbox[i].get_node("LineEdit").editable = !readmode

func _on_CheckBox_toggled(button_pressed, idx):
	array_checkbox[idx].get_node("LineEdit").editable = button_pressed
