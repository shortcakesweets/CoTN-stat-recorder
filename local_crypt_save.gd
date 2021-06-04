# Local crypt save
# acts like settings savings too

extends Node

var crypt_slot : Array = []

func _ready():
	crypt_slot.clear()
	
	font_size = 12
	username = "Anonymous"
	
	load_userdata()
	save_userdata()

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

#########################################################

# settings saving

var font_size : int
var username : String

func save_userdata() -> void:
	var save_file = File.new()
	save_file.open("user://userdata.save", File.WRITE)
	
	save_file.store_line(to_json(font_size))
	save_file.store_line(to_json(username))
	
	save_file.close()

func load_userdata() -> bool:
	var save_file = File.new()
	if not save_file.file_exists("user://userdata.save") :
		return false
	
	save_file.open("user://userdata.save", File.READ)
	
	font_size = parse_json(save_file.get_line())
	username = parse_json(save_file.get_line())
	
	save_file.close()
	
	return true

##########################################################

# load seed inputs (or daily seeds)

var daily_seed : int
var seed_loader : int = -1

func save_seed(target_seed : int) -> void:
	seed_loader = target_seed
	return

func load_seed() -> int:
	var target_seed = seed_loader
	seed_loader = -1 # reset seed_loader
	
	return target_seed





