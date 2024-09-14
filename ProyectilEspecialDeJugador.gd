extends KinematicBody2D


export var sprite="WaterShot"
export var x_speed=90
var velocity=Vector2.ZERO
var direccion=Vector2.ZERO
var player=Vector2.ZERO
var sonido
var flipSprite=false
func _ready():
	if flipSprite:
		scale.x=-1
	else: scale.x=1
	match sprite:
		"WaterShot":
			$AnimatedSprite.animation="WaterShot"
	$Timer.start()

func _physics_process(delta):
	velocity=velocity.move_toward(x_speed*direccion,300*delta)
	move_and_slide(velocity)
	if !$AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.stream=load(sonido)
		$AudioStreamPlayer2D.play()

func _on_Hitbox_area_entered(area):
	queue_free()


func _on_Hitbox_body_entered(body):
	if body.name!=get_parent().name && body.name!="ProyectilEspecialDeJugador":
		queue_free()


func _on_Timer_timeout():
	queue_free()
