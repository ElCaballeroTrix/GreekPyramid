extends KinematicBody2D

var gravity=2
var velocidad=Vector2.ZERO


func _ready():
	pass 
func _physics_process(delta):
	velocidad.x=0
	velocidad.y+=gravity
	velocidad=move_and_slide(velocidad,Vector2(0,-1))


