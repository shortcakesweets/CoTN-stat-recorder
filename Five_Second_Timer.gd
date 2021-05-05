extends TextureProgress

onready var tween = $Tween
onready var label = $Label
onready var timer = $Timer

func _ready():
	pass

func _start_timer(countdown = 5, tween_duration = 1):
	for i in range(countdown) :
		
		label.text = "%d" % (5-i)
		
		tween.stop_all()
		tween.interpolate_property(self, "value", 100, 0, tween_duration, Tween.TRANS_LINEAR)
		tween.start()
		yield(tween, "tween_completed")
	
	label.text = "GO!"
	
	timer.start()

func _on_Timer_timeout():
	#self.queue_free()
	self.visible = false
	pass
