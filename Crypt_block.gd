extends Control

export var BLOCK_NUM : int = 0
signal touch_detected

onready var death_label = get_node("death")
onready var GUI_build = get_node("GUI_Build")
onready var touchscreen = get_node("touchscreen")

onready var runtime_label = get_node("runtime")

onready var outline : Line2D = get_node("Outline")
onready var inline_vertical : Line2D = get_node("Inline_vertical")
onready var inline_horizontal : Line2D = get_node("Inline_horizontal")

# fonts
onready var font_maximum : DynamicFont = load("res://necrosans/font_maximum.tres")
onready var font_large : DynamicFont = load("res://necrosans/font_large.tres")
onready var font_medium : DynamicFont = load("res://necrosans/font_medium.tres")
onready var font_small : DynamicFont = load("res://necrosans/font_small.tres")
# onready var font_minimum : DynamicFont = load("res://necrosans/font_minimum.tres")

func _ready():
	var pixel_size = get_parent_rect()
	resize(pixel_size.x, pixel_size.y)
	
	sync_text_size()
	
	set_color(Color.aqua) # Default
	
	pass

func set_block_data_by_idx(index : int) -> void:
	set_block_data( _get_crypt_by_idx(index) )
	
	return

func set_block_data(crypt : Crypt) -> void:
	set_death( crypt.death )
	set_runtime( crypt.rta, crypt.igt )
	set_build( crypt.build )
	
	return

### Helper functions ###

func get_parent_rect() -> Vector2 :
	var parent = get_node("..")
	#print(parent.rect_size)
	
	if "rect_size" in parent :
		return parent.rect_size
	else :
		return Vector2(500,600)

func get_parent_anchor() -> Vector2 :
	var parent = get_node("..")
	
	if "anchor_right" in parent:
		return Vector2(parent.anchor_right - parent.anchor_left, parent.anchor_bottom - parent.anchor_top)
	else :
		return Vector2(0,0)

# Resize with pixels. get data of rect size's width/height
func resize(width = 500, height = 200) -> void:
	# Default settings
	#  width = 500, height = 200 (all parameters are altered by these. width : height is always 5:2)
	
	# Debug
	#print(" Parent Pixel Size : ")
	#print(width, height)
	
	var anchor_ratio : float
	var Origin : Vector2
	var Margin : float
	
	if height != 0 :
		anchor_ratio = (width * 0.4) / height
		print(anchor_ratio)
	else :
		anchor_ratio = 0.4
	
	# Default margin = 0.05
	Margin = 0.05
	
	self.anchor_bottom = anchor_ratio * (BLOCK_NUM + 1) + Margin * BLOCK_NUM
	self.anchor_left = 0
	self.anchor_right = 1
	self.anchor_top = anchor_ratio * (BLOCK_NUM) + Margin * BLOCK_NUM
	
	self.margin_bottom = 0
	self.margin_right = 0
	self.margin_top = 0
	self.margin_left = 0
	
	var pixel_size : Vector2 = self.rect_size
	Origin = Vector2.ZERO
	
	#  death_label is set by inspecter.
	#  GUI_build is set by inspecter.
	#  rta(igt) is set by inspecter
	
	outline.points = [Origin, Origin + Vector2(pixel_size.x, 0), Origin + Vector2(pixel_size.x,pixel_size.y), Origin + Vector2(0,pixel_size.y), Origin]
	inline_vertical.points = [Origin + Vector2(0.4 * pixel_size.x , 0), Origin + Vector2(0.4 * pixel_size.x, pixel_size.y)]
	inline_horizontal.points = [Origin + Vector2(0.4 * pixel_size.x, 0.5 * pixel_size.y), Origin + Vector2(pixel_size.x, 0.5 * pixel_size.y)]
	
	# touchscreen (button) is set by inspecter

func sync_text_size() -> void:
	# Text size varies by resolution
	#   minimum : x1 (don't use this size)
	#   small : x2
	#   medium : x3
	#   big : x4
	#   maximum : x6
	#
	# on 750 * 1330 androids, we use x1 as 12 pixels.
	#  (small : 24px, maximum : 76px)
	
	var text_size = LocalCryptSave.font_size
	
	#var width = get_viewport().size.x
	# var height = get_viewport().size.y
	
	font_maximum.size = text_size * 6
	font_large.size = text_size * 4
	font_medium.size = text_size * 3
	font_small.size = text_size * 2
	# font_minimum.size = text_size * 1
	
	var GROUP_font_maximum = get_tree().get_nodes_in_group("font_maximum")
	var GROUP_font_large = get_tree().get_nodes_in_group("font_large")
	var GROUP_font_medium = get_tree().get_nodes_in_group("font_medium")
	var GROUP_font_small = get_tree().get_nodes_in_group("font_small")
	# var GROUP_font_minimum = get_tree().get_nodes_in_group("font_minimum")
	
	for target_node in GROUP_font_maximum :
		if "custom_fonts/font" in target_node :
			target_node.set("custom_fonts/font", font_maximum)
	
	for target_node in GROUP_font_large :
		if "custom_fonts/font" in target_node :
			target_node.set("custom_fonts/font", font_large)
	
	for target_node in GROUP_font_medium :
		if "custom_fonts/font" in target_node :
			target_node.set("custom_fonts/font", font_medium)
	
	for target_node in GROUP_font_small :
		if "custom_fonts/font" in target_node :
			target_node.set("custom_fonts/font", font_small)
	
	# Skip minimum nodes.
	
	return

func set_data(death = "-", rta_time = 0.0, igt_time = 0.0, build = []) -> void :
	set_death(death)
	set_runtime(rta_time, igt_time)
	set_build(build)
	
	if rta_time == 0 && igt_time == 0 :
		set_color(Color.orange)
	else :
		set_color(Color.aqua)

func set_death(death : String) -> void:
	death_label.text = death

func set_runtime(rta_time : float, igt_time : float) -> void:
	
	var rta_ms = fmod(rta_time, 1) * 1000
	var rta_seconds = fmod(rta_time, 60)
	var rta_minutes = fmod(rta_time, 3600) / 60
	var rta_elapsed = "%02d:%02d.%02d" % [rta_minutes, rta_seconds, rta_ms]
	
	var igt_ms = fmod(igt_time, 1) * 1000
	var igt_seconds = fmod(igt_time,60)
	var igt_minutes = fmod(igt_time, 3600) / 60
	var igt_elapsed = "%02d:%02d.%02d" % [igt_minutes, igt_seconds, igt_ms]
	
	runtime_label.text = rta_elapsed + "\n" + "(igt : " + igt_elapsed + ")"

func set_build(build : Array) -> void:
	# need implement. wip
	return

func set_color(color : Color) -> void :
	outline.default_color = color
	inline_vertical.default_color = color
	inline_horizontal.default_color = color
	
	return

func _get_crypt_by_idx(index : int) -> Crypt:
	# request to server
	
	# after implementing server request, erase this part #
	var temp_crypt = Crypt.new()
	return temp_crypt
	######################################################
	
	pass

func _on_touchscreen_pressed():
	emit_signal("touch_detected")
