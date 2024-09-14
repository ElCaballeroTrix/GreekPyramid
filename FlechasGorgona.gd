extends Area2D

var move=Vector2.ZERO
var look_vector=Vector2.ZERO
var speed=3

func _ready():
	pass

func _physics_process(delta):
	move=Vector2.ZERO
	move=move.move_toward(look_vector,delta)
	move=move.normalized()*speed
	position+=move

func _on_Area2D_area_entered(area):
	queue_free()

func _on_Area2D_body_entered(body):
	queue_free()
