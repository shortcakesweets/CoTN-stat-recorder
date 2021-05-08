extends ItemList

# Defines a dictionary of Items, item codes

var armor : Dictionary = {
	"leather" : 0,
	"chainmail" : 1,
	"platemail" : 2, 
	"heavyplate" : 3,
	"obsidian" : 4,
	"gi" : 5, 
	"glass" : 6,
	"quartz" : 7,
	"heavyglass" : 8
}

var feet : Dictionary = {
	"ballet" : 9,
	"explorers" : 10,
	"lead" : 11,
	"leaping" : 12,
	"lunging" : 13,
	"pain" : 14,
	"strength" : 15,
	"floating" : 16,
	"glass" : 17,
	"hardgreaves" : 18
}

var head : Dictionary = {
	"blast_helm" : 19,
	"telepathy" : 20,
	"thorns" : 21,
	"glass_jaw" : 22,
	"helmet" : 23,
	"miners_cap" : 24,
	"monocle" : 25,
	"spiked_ears" : 26,
	"sunglasses" : 27
}

var misc : Dictionary = {
	"charm_grenade" : 28,
	"charm_bomb" : 29,
	"charm_frost" : 30,
	"charm_gluttony" : 31,
	"charm_nazar" : 32,
	"charm_protection" : 33,
	"charm_risk" : 34,
	"charm_strength" : 35,
	"monkey_paw" : 36,
	"compass" : 37,
	"map" : 38,
	"potion" : 39
}

var pickup : Dictionary = {
	"blood_drum" : 40,
	"cursed_potion" : 41,
	"holy_water" : 42,
	"scroll_earthquake" : 43,
	"scroll_need" : 44,
	"scroll_enchant" : 45,
	"familiar_dove" : 46,
	"familiar_ice" : 47,
	"familiar_rat" : 48,
	"familiar_shop" : 49
}

var ring : Dictionary = {
	"becoming" : 50,
	"charisma" : 51,
	"courage" : 52,
	"regen" : 53,
	"frost" : 54,
	"gold" : 55,
	"luck" : 56,
	"mana" : 57,
	"might" : 58,
	"pain" : 59,
	"peace" : 60,
	"piercing" : 61,
	"protection" : 62,
	"shadow" : 63,
	"war" : 64,
	"wonder" : 65
}

var shovel : Dictionary = {
	"battle" : 66,
	"blood" : 67,
	"courage" : 68,
	"glass" : 69,
	"crystal" : 70,
	"strength" : 71
}

var spell : Dictionary = {
	"pulse_spell" : 72,
	"pulse_scroll" : 73,
	"pulse_tome" : 74,
	"shield_spell" : 75,
	"shield_scroll" : 76,
	"shield_tome" : 77,
	"fireball_spell" : 78,
	"fireball_scroll" : 79,
	"fireball_tome" : 80,
	"freeze_spell" : 81,
	"freeze_scroll" : 82,
	"freeze_tome" : 83,
	"transmute_spell" : 84,
	"transmute_scroll" : 85,
	"transmute_tome" : 86,
	"earth_spell" : 87,
	"earth_tome" : 88,
	"heal_spell" : 89,
	"bomb_spell" : 90
}

# var tile : Dictionary = {}

var torch : Dictionary = {
	"strength" : 91,
	"base" : 92,
	"bright" : 93,
	"luminous" : 94,
	"obsidian" : 95,
	"foresight" : 96,
	"glass" : 97,
	"walls" : 98,
	"infernal" : 99
}

var weapon : Dictionary = {
	"axe" : 100,
	"cat" : 101,
	"rapier" : 102,
	"electric" : 103,
	"frost" : 104,
	"phasing" : 105,
	"jeweled" : 106,
	"longsword" : 107,
	"staff" : 108,
	"cutlass" : 109,
	"gun_rifle" : 110,
	"gun_blunderbuss" : 111,
	"bow" : 112,
	"cross_bow" : 113,
	"broadsword" : 114,
	"whip" : 115,
	"warhammer" : 116,
	"flail" : 117,
	"harp" : 118,
	"spear" : 119
}

var item_list : Dictionary = {
	"armor" : armor,
	"feet" : feet,
	"head" : head,
	"misc" : misc,
	"pickup" : pickup,
	"ring" : ring,
	"shovel" : shovel,
	"spell" : spell,
	"torch" : torch,
	"weapon" : weapon
}

var how_list : Dictionary = {
	"shop" : 0,
	"mimic_shrine" : 1,
	"mimic_chest" : 2,
	"urn" : 3,
	"chest" : 4,
	"crate" : 5,
	"arena" : 6,
	"blood_shop" : 7,
	"glass_shop" : 8,
	"food_shop" : 9,
	"conjurer" : 10,
	"shriner" : 11,
	"pawnbroker" : 12,
	"transmog" : 13,
	"shrine_boss" : 14,
	"shrine_blood" : 15,
	"shrine_chance" : 16,
	"shrine_darkness" : 17,
	"shrine_glass" : 18,
	"shrine_pain" : 19,
	"shrine_mystery" : 20,
	"shrine_peace" : 21,
	"shrine_rhythm" : 22,
	"shrine_risk" : 23,
	"shrine_sacrifice" : 24,
	"shrine_space" : 25,
	"shrine_war" : 26,
	"sss" : 27,
	"transmute" : 28
}

func _ready():
	pass

func item_find_text_by_index(index : int) -> String:
	for sub_text in item_list :
		if typeof(item_list[sub_text]) != TYPE_DICTIONARY :
			print(" sub_dic is not a dictionary")
			continue
		
		var sub_dic : Dictionary = item_list[sub_text]
		
		for item_text in sub_dic :
			if sub_dic[item_text] == index : 
				return sub_text + "_" + item_text
	
	return "null"

func how_find_text_by_index(index : int) -> String:
	for how_text in how_list :
		if how_list[how_text] == index :
			return how_text
	
	return "null"
