extends Area2D

var move=Vector2.ZERO
var direccion=Vector2.ZERO
var sprite="default"
var speed=3
var vida=4
var sonido
func _ready():
	#Si se pone sonido, que no lo haga
	if sonido!="":
		$AudioStreamPlayer2D.stream=load(sonido)
	$AudioStreamPlayer2D.play()
	$AnimatedSprite.frame=0
	$CollisionShape2D.position.x=-0.583
	if sprite=="Flecha(Ballestero)":
		$Hitbox/CollisionShape2D.position.x=-2.418
		$Hitbox/CollisionShape2D.position.y=-0.615
		$AnimatedSprite.scale.x=1
		$AnimatedSprite.scale.y=1
		$Particles2D.position.x=-13.735
		$Particles2D.scale.x=-1
		$FireEffect.emitting=false
	elif sprite=="Flecha(Gorgona)":
		$CollisionShape2D.position.x=2
		$Hitbox/CollisionShape2D.position.x=2.655
		$Hitbox/CollisionShape2D.position.y=-0.615
		$AnimatedSprite.scale.x=1
		$AnimatedSprite.scale.y=1
		$Particles2D.position.x=13.735
		$Particles2D.scale.x=1
		$FireEffect.emitting=false
	elif sprite=="Tinta":
		$Hitbox/CollisionShape2D.position.x=0.449
		$Hitbox/CollisionShape2D.position.y=-0.099
		$Particles2D.emitting=false
		$AnimatedSprite.scale.x=0.5
		$AnimatedSprite.scale.y=0.5
		$FireEffect.emitting=true
		var gradientTexture=GradientTexture.new()
		var gradient=Gradient.new()
		gradient.colors=([Color(0.65,0.57,0.57,1),Color(0.65,0.57,0.57,0.67),Color(0.3,0.29,0.29,0.48)])
		gradient.offsets=([0.0,0.446,1.0])
		gradientTexture.gradient=gradient
		gradientTexture.width=2048
		$FireEffect.get_process_material().color_ramp=gradientTexture



func _physics_process(delta):
	move=Vector2.ZERO
	move=move.move_toward(direccion,delta)
	move=move.normalized()*speed
	position+=move
	$AnimatedSprite.play(sprite)


func _on_Area2D_area_entered(area):
	queue_free()

func _on_Area2D_body_entered(body):
	queue_free()
