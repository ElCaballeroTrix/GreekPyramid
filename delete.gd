extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocidad=Vector2.ZERO
var accelaration=300
var max_speed=30
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	movimiento(delta)


func movimiento(delta):
	velocidad=velocidad.move_toward(Vector2(1,0),accelaration * delta)
	velocidad.y=0
	velocidad=velocidad.normalized()*max_speed
	position+=velocidad
