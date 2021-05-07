# Local crypt save

extends Node

var crypt_slot : Array = []

func _ready():
	crypt_slot.clear()

# if array is empty, give Crypt.new()
func get_latest_crypt_from_array() -> Crypt :
	var target_crypt : Crypt
	
	if crypt_slot.empty() :
		target_crypt = Crypt.new()
		return target_crypt
	
	else :
		target_crypt = crypt_slot.pop_back()
		return target_crypt

# push a crypt to crypt_slot
func push_crypt_to_array(target_crypt : Crypt) -> void :
	crypt_slot.append(target_crypt)
