extends KinematicBody2D


var velocidad=Vector2.ZERO
var knockback=Vector2.ZERO
onready var stats=$Stats
onready var playerDetectionZone=$PlayerDetectionZone
onready var playerAttackZone=$AttackZone
onready var softCollision=$SoftCollision
export (int) var circleplayerDetectionZone
export (int) var screenShakeLength
export (int) var screenShakepower
export (String) var sonidoGolpeEnSuelo
export (String) var sonidoTransformacion
export var accelaration=200
export var max_speed=90
export var friction=200
export var gravedad=280
export (bool) var imagen_perfil=true
var direction=1
var pointOfAttack
var waitingUp=false
var earthquake=false
var statueForm=true #Esta con un solo color y quieto
enum{
	IDLE,
	CHASE,
	ATTACK
}
var state=CHASE

func _ready():
	$EnemySprite.frame=0
	var radioColision=CircleShape2D.new()
	radioColision.radius=circleplayerDetectionZone
	$PlayerDetectionZone/CollisionShape2D.shape=radioColision
	$EffectsSprite.visible=false
	$Effects2Sprite.visible=false
	$EffectsAnimation.playback_speed=2
	state=IDLE

func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,friction*delta)
	knockback=move_and_slide(knockback,Vector2.UP)
#	if velocidad.x==0:
#		$AnimationPlayer.play("IdleStatue")
#		$AudioStreamPlayer2D.stop()
	match state:
		IDLE:
			velocidad=velocidad.move_toward(Vector2.ZERO,friction*delta)
			seek_player()
		CHASE:
			var player=playerDetectionZone.player
			if player!=null:
				accelerate_towards_point(player.global_position,delta)
			else: 
				state=IDLE
			velocidad.y+=500*delta
		ATTACK:
			attackFunction(delta)
			if !earthquake:
				velocidad.y+=500*delta
	if softCollision.is_colliding():
		velocidad+=softCollision.get_push_vector()*delta*400
	velocidad=move_and_slide(velocidad,Vector2.UP)


func accelerate_towards_point(point,delta):
	var direccion=global_position.direction_to(point)
	velocidad=velocidad.move_toward(direccion * max_speed,accelaration * delta)
	$Hurtbox.knockback_vector.x=direccion.x
	$Hurtbox.knockback_vector.y=direccion.y * -1
	$Hitbox.knockback_vector.x=direccion.x
	$Hitbox.knockback_vector.y=direccion.y
	if imagen_perfil:
		$EnemySprite.flip_h=velocidad.x>0
	if playerAttackZone.can_see_player():
		pointOfAttack=playerDetectionZone.player.global_position
		if statueForm:
			$AudioStreamPlayer2D.stream=load(sonidoTransformacion)
			$AudioStreamPlayer2D.play()
			#Particulas
			$Particles2D.emitting=true
			statueForm=false
		$AnimationPlayer.play("AttackStatue")
		state=ATTACK

func seek_player():
	if playerDetectionZone.can_see_player():
		var radioColision=CircleShape2D.new()
		radioColision.radius=circleplayerDetectionZone*2
		$PlayerDetectionZone/CollisionShape2D.shape=radioColision
		state=CHASE

func attackFunction(delta):
	if is_on_floor() && waitingUp:
		$AudioStreamPlayer2D.stream=load(sonidoGolpeEnSuelo)
		$AudioStreamPlayer2D.play()
		$ScreenShake.screen_shake(screenShakeLength,screenShakepower,2)
		$EffectsAnimation.play("WaveAttack")
		velocidad.x=0
		earthquake=true
		yield(get_tree().create_timer(0.5),"timeout")
		waitingUp=false
		earthquake=false
		state=CHASE
	elif !waitingUp:
		var direccion=global_position.direction_to(pointOfAttack)
		velocidad=velocidad.move_toward(direccion * max_speed,accelaration * delta)
		velocidad.y=-gravedad*0.5

func attackGoUp():
	accelaration=250
	max_speed=200
	if gravedad<0:
		gravedad=-gravedad
	if playerDetectionZone.player!=null:
		pointOfAttack=playerDetectionZone.player.global_position
	else: 
		pointOfAttack=global_position
	pointOfAttack.y=pointOfAttack.y-200

func waitInClouds():
	waitingUp=true
	velocidad=Vector2.ZERO


func _on_Stats_no_health():
	$Hurtbox.create_hit_effect()
	queue_free()


func _on_Hitbox_area_entered(area):
	var interferencia=global_position - area.global_position
	knockback.x=sign(interferencia.x)*(accelaration/1.5)



func _on_Hurtbox_invincibility_started():
	$BlinkAnimation.play("BlinkStatue")


func _on_Hurtbox_invincibility_ended():
	$BlinkAnimation.play("StopBlinkStatue")


func _on_Hurtbox_area_entered(area):
#	knockback=area.knockback_vector*200
#	knockback.y=0
	stats.health-=area.damage
	$Hurtbox.start_invincibility(0.4)
