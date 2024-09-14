extends KinematicBody2D


var velocidad=Vector2.ZERO
var knockback=Vector2.ZERO
onready var stats=$Stats
onready var positionRight=$"../PositionRight"
onready var positionLeft=$"../PositionLeft"
onready var softCollision=$SoftCollision
onready var Jugador=get_tree().get_root().get_node(rutaJugador)
onready var playerDetectionZone = $"../PlayerDetectionZone"
export (String) var rutaJugador
export var accelaration=200
export var max_speed=90
export var friction=200
export var sonidoGolpe = ""
export (bool) var imagen_perfil=true
var direction=1
var edge=false
enum{
	IDLE,
	CHASE,
}
var state=CHASE

func _ready():
	$Hurtbox.knockback_vector=Vector2.LEFT
	Jugador.connect("comienzaStunGorgona",self,"estuneado")
	Jugador.connect("acabaStunGorgona",self,"finestuneado")

func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,friction*delta)
	knockback=move_and_slide(knockback)
	if $RayCast2D.is_colliding()==false:
		edge=true
		velocidad.x=0
		if knockback!=Vector2.ZERO:
			knockback=knockback*(-0.5)
	elif $RayCast2D2.is_colliding()==false:
		edge=true
		velocidad.x=0
		if knockback!=Vector2.ZERO:
			knockback=knockback*(-0.5)
	else:
		edge=false
	match state:
		IDLE:
			velocidad=velocidad.move_toward(Vector2.ZERO,friction*delta)
			if edge==false:
				seek_player()
			if global_position <= positionLeft.global_position: 
				direction = 1
			if global_position >= positionRight.global_position:
				direction = -1
			if direction == 1:
				accelerate_towards_point(positionRight.global_position, delta)
			if direction == -1:
				accelerate_towards_point(positionLeft.global_position, delta)
		CHASE:
			var player=playerDetectionZone.player
			if player!=null:
				if edge==true:
					state=IDLE
				else:
					accelerate_towards_point(player.global_position,delta)
			else: 
				state=IDLE
	if softCollision.is_colliding():
		velocidad+=softCollision.get_push_vector()*delta*400
	velocidad=move_and_slide(velocidad)

func accelerate_towards_point(point,delta):
	var direccion=global_position.direction_to(point)
	direction = round(direccion.x)
	velocidad=velocidad.move_toward(direccion * max_speed,accelaration * delta)
	velocidad.y=0
	$Hurtbox.knockback_vector.x=direccion.x
	$Hurtbox.knockback_vector.y=direccion.y * -1
	$Hitbox.knockback_vector.x=direccion.x
	$Hitbox.knockback_vector.y=direccion.y
	if imagen_perfil:
		$Sprite.flip_h=velocidad.x>0

func seek_player():
	if playerDetectionZone.can_see_player():
		state=CHASE

func _on_Hurtbox_area_entered(area):
	knockback=area.knockback_vector*200
	knockback.y=0
	stats.health-=area.damage
	$Hurtbox.start_invincibility(0.4)


func _on_Stats_no_health():
	$Hurtbox.create_hit_effect()
	queue_free()


func _on_Hitbox_area_entered(area):
	var interferencia=global_position - area.global_position
	knockback.x=sign(interferencia.x)*(accelaration/1.5)
	$AudioStreamPlayer2D.stream=load(sonidoGolpe)
	$AudioStreamPlayer2D.play()


func _on_Hurtbox_invincibility_started():
	$Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$BlinkAnimationPlayer.play("StartBlink")


func _on_Hurtbox_invincibility_ended():
	$Hitbox/CollisionShape2D.set_deferred("disabled",false)
	$BlinkAnimationPlayer.play("StopBlink")

func estuneado(cuerpo):
	if self==cuerpo:
		$AnimatedSprite.stop()
		$AnimatedSprite.material.shader=load("res://Shaders/Piedra.shader")
func finestuneado():
	$AnimatedSprite.material.shader=load("res://Shaders/Blink.shader")
	$AnimatedSprite.play()

