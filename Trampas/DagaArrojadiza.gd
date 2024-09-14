extends Area2D


var move=Vector2.ZERO
var direccion=Vector2.ZERO
var speed=3
var sprite="default"
var sonido

func _ready():
	$AudioStreamPlayer2D.play()

func _physics_process(delta):
	move=Vector2.ZERO
	move=move.move_toward(direccion,delta)
	move=move.normalized()*speed
	position+=move
func _on_DagaArrojadiza_body_entered(body):
	queue_free()

func _on_DagaArrojadiza_area_entered(area):
	queue_free()
