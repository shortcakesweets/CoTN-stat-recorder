extends Area2D

onready var collision_shape = $CollisionShape2D

func _ready():
	#self.connect("input_event", self, "_on_TouchScreen_input_event")
	
	print(is_connected('input_event', self, '_on_Area2D_input_event'))
	
	#collision_shape.shape.extents.x = 0.5 * get_viewport().size.x
	#collision_shape.shape.extents.y = 0.5 * get_viewport().size.y
	#collision_shape.position = Vector2( collision_shape.shape.extents.x, collision_shape.shape.extents.y )
	
	print(collision_shape.position, collision_shape.shape.extents.x, collision_shape.shape.extents.y)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton :
		if event.doubleclick :
			# Debug
			#print('double click ', event)
			pass
		else :
			#print('single click', event)
			pass
