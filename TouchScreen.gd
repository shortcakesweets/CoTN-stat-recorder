extends Area2D

onready var collision_shape = $CollisionShape2D

func _ready():
	collision_shape.shape.extents.x = 0.5 * get_viewport().size.x
	collision_shape.shape.extents.y = 0.5 * get_viewport().size.y
	collision_shape.position = Vector2( collision_shape.shape.extents.x, collision_shape.shape.extents.y )

func _on_TouchScreen_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton :
		if event.doubleclick :
			pass
			#print('double click ', event)
		else :
			#print('single click', event)
			pass
