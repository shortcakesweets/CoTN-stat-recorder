extends Node2D

var rng = RandomNumberGenerator.new()

var crypt_array = []
var crypt : Crypt

func _ready():
	crypt_array.clear()
	
	for i in range(10) :
		crypt_array.append( make_test_subjects() )
	

func make_test_subjects() -> Crypt:
	rng.randomize()
	
	var test_crypt = Crypt.new()
	
	test_crypt.Character = test_crypt.Cadence
	test_crypt.Mod = test_crypt.NORMAL
	test_crypt.igt = rng.randi_range(10000, 100000)
	test_crypt.rta = test_crypt.igt
	test_crypt.random_seed = rng.randi_range(10000,9999999)
	test_crypt.death = "5-6"
	test_crypt.isWin = true
	
	return test_crypt
