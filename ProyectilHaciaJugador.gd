extends KinematicBody2D


export var sprite="WaterShot"
export var x_speed=90
var velocity=Vector2.ZERO
var direccion=Vector2.ZERO
var player=Vector2.ZERO
var rotationBala=0
var sonido
func _ready():
	rotation=rotationBala
	var capsula
	match sprite:
		"WaterShot":
			$AnimatedSprite.animation="WaterShot"
			$Hitbox/CollisionShape2D.position=Vector2(0,-2.251)
			capsula=CapsuleShape2D.new()
			capsula.radius=1.332 
			capsula.height=5.716
		"Moco":
			$AnimatedSprite.animation="Moco"
			$Hitbox/CollisionShape2D.position=Vector2(0,-0.17)
			capsula=CapsuleShape2D.new()
			capsula.radius=2.5
			capsula.height=1
	$Hitbox/CollisionShape2D.shape=capsula

func _physics_process(delta):
	velocity=velocity.move_toward(x_speed*direccion,200*delta)
	move_and_slide(velocity)
	if !$AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.stream=load(sonido)
		$AudioStreamPlayer2D.play()

func _on_Hitbox_area_entered(area):
	if area.name!="TentaculoArriba":
		queue_free()

func _on_Hitbox_body_entered(body):
	#Esto se añade para que se destruya cuando toque TileMap o un objeto
	if body.name!=get_parent().name and body.get_parent().name!=get_parent().name:
		queue_free()
