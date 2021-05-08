extends Object

class_name Crypt

enum {Cadence, Melody, Aria, Dorian, Eli, Monk, Dove, Coda, Bolt, Bard, Nocturna, Diamond, Mary, Tempo, Reaper}
enum {NORMAL, CoNDOR}

var player_name : String

var Character
var Mod
var igt : float
var rta : float
var random_seed : int
var death : String
var isWin : bool

var division : Array # Array of time (rta's)
# division[0] : Time entered in z2
# division[1] : Time entered in z3
# division[2] : Time entered in z4
# division[3] : Time entered in z5

# Only for Cadence / Nocturna (who has two bosses)

# division[4] : Time entered in Boss_1
# division[5] : Time entered in Boss_2

var build : Array # Array of Build

class Build :
	
	# Can be AnimatedTexture, StreamTexture, Texture etc
	var item_texture
	var where_texture
	var how_texture
	
	var item
	var where
	var how
	
	# where : 1-1 ~ 5-3, idk
	# how : blood_shop, shrine_of_peace, chest, used_transmute etc, idk

func _init():
	player_name = "Anonymous"
	Character = Cadence
	Mod = NORMAL
	igt = 0
	rta = 0
	random_seed = 123456
	death = "1-1"
	isWin = false
	build = []
