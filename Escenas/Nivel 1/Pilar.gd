extends Area2D

var velocidad=Vector2.ZERO
var speed=2.5
var direccion=Vector2.ZERO
export var sprite="default"
var sonido
func _ready():
	pass

func _physics_process(delta):
	velocidad=Vector2.ZERO
	velocidad=velocidad.move_toward(direccion,delta)
	velocidad=velocidad.normalized()*speed
	position+=velocidad
	$AnimatedSprite.play(sprite)

func _on_Area2D_area_entered(area):
	$AudioStreamPlayer2D.stream=load(sonido)
	$AudioStreamPlayer2D.play()
	queue_free()


func _on_Area2D_body_entered(body):
	if body.name=="TileMap":
		$AudioStreamPlayer2D.stream=load(sonido)
		$AudioStreamPlayer2D.volume_db=-10
		$AudioStreamPlayer2D.play()
		$AnimatedSprite.visible=false
		$Hitbox/CollisionShape2D.set_deferred("disabled",true)
		$CollisionShape2D.set_deferred("disabled",true)
		$TimerPilar.start()
	else:
		queue_free()


func _on_TimerPilar_timeout():
	queue_free()
