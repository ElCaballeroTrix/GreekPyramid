extends Particles2D

func _ready():
	$TimerPolvo.start()


func _on_TimerPolvo_timeout():
	queue_free()
