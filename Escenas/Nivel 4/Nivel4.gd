extends Node2D

export(PackedScene) var fireball
onready var fireballLauncher = $Fireballs


# Called when the node enters the scene tree for the first time.
func _ready():
	var fireballInstance=fireball.instance()
	fireballInstance.direccion=Vector2(0,1)
	#fireballInstance.sonido=sonido
	fireballInstance.speed=3
	add_child(fireballInstance)
	var range1 =randi()%3
	print("Range: ",range1,", ejem: ",fireballLauncher.get_child(1).name)
	fireballInstance.global_position=fireballLauncher.get_child(range1).global_position

#func _process(delta):
#	pass
