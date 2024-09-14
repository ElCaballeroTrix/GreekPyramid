extends Node2D

export var areLeftRightChildrenActivated = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if !areLeftRightChildrenActivated:
		$Chain/ChainChildLeft.queue_free()
		$Chain/ChainChildRight.queue_free()



func _on_Timer_timeout():
	$AnimationPlayer.play("Columpio")
