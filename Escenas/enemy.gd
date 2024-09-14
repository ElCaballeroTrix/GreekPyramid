extends KinematicBody2D


var velocidad=Vector2.ZERO
var knockback=Vector2.ZERO
onready var stats=$Stats
onready var playerDetectionZone=$PlayerDetectionZone
onready var softCollision=$SoftCollision
onready var wanderController=$WanderController
export (String) var rutaJugador
onready var Jugador=get_tree().get_root().get_node(rutaJugador)
export (String) var sonido
export var sonidoAndando=""
export var accelaration=200
export var max_speed=90
export var friction=200
export var wander_target_range=4
export (bool) var imagen_perfil=true
var direction=1
var edge=false
enum{
	IDLE,
	CHASE,
	WANDER
}
var state=CHASE

func _ready():
	state=pick_random_state([IDLE,WANDER])
	$Hurtbox.knockback_vector=Vector2.LEFT
	Jugador.connect("comienzaStunGorgona",self,"estuneado")
	Jugador.connect("acabaStunGorgona",self,"finestuneado")

func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,friction*delta)
	knockback=move_and_slide(knockback)
	if velocidad.x==0:
		$AnimatedSprite.play("default")
		$AudioStreamPlayer2D.stop()
	else: 
		if sonidoAndando!="" && !$AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.stream=load(sonidoAndando)
			$AudioStreamPlayer2D.play()
		$AnimatedSprite.play("enemigo")
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
	if edge==true:
		$PlayerDetectionZone/CollisionShape2D.scale.x=0.2
		$Tiempo_Sin_Deteccion.start()
		state=WANDER
	#if edge==true and $RayCast2D.is_colliding()==false:
	#	velocidad=velocidad.move_toward(Vector2(-1*300,0),accelaration*delta)
	#elif edge==true and $RayCast2D2.is_colliding()==false:
	#	velocidad=velocidad.move_toward(Vector2(1*max_speed,0),accelaration*delta)
	match state:
		IDLE:
			velocidad=velocidad.move_toward(Vector2.ZERO,friction*delta)
			if edge==false:
				seek_player()
			if wanderController.get_time_left()==0:
				update_wander()
		WANDER:
			if edge==false:
				seek_player()
			if wanderController.get_time_left()==0:
				update_wander()
			accelerate_towards_point(wanderController.target_position,delta)
			if global_position.distance_to(wanderController.target_position)<=wander_target_range:
				update_wander()
		CHASE:
			var player=playerDetectionZone.player
			if player!=null:
				if edge==true:
					state=IDLE
					#state=pick_random_state([IDLE,WANDER])
				else:
					accelerate_towards_point(player.global_position,delta)
			else: 
				state=IDLE
	if softCollision.is_colliding():
		velocidad+=softCollision.get_push_vector()*delta*400
	velocidad=move_and_slide(velocidad)

func update_wander():
	state=pick_random_state([IDLE,WANDER])
	wanderController.start_wander_timer(rand_range(1,3))

func accelerate_towards_point(point,delta):
	var direccion=global_position.direction_to(point)
	velocidad=velocidad.move_toward(direccion * max_speed,accelaration * delta)
	velocidad.y=0
	$Hurtbox.knockback_vector.x=direccion.x
	$Hurtbox.knockback_vector.y=direccion.y * -1
	$Hitbox.knockback_vector.x=direccion.x
	$Hitbox.knockback_vector.y=direccion.y
	if imagen_perfil:
		$AnimatedSprite.flip_h=velocidad.x>0

func seek_player():
	if playerDetectionZone.can_see_player():
		state=CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

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
	$AudioStreamPlayer2D.stream=load(sonido)
	$AudioStreamPlayer2D.play()


func _on_Hurtbox_invincibility_started():
	$Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$BlinkAnimationPlayer.play("StartBlink")


func _on_Hurtbox_invincibility_ended():
	$Hitbox/CollisionShape2D.set_deferred("disabled",false)
	$BlinkAnimationPlayer.play("StopBlink")


func _on_Tiempo_Sin_Deteccion_timeout():
	if edge==false: $PlayerDetectionZone/CollisionShape2D.scale.x=1

func estuneado(cuerpo):
	if self==cuerpo:
		$AnimatedSprite.stop()
		$AnimatedSprite.material.shader=load("res://Shaders/Piedra.shader")
func finestuneado():
	$AnimatedSprite.material.shader=load("res://Shaders/Blink.shader")
	$AnimatedSprite.play()
