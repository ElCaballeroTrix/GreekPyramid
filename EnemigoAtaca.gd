extends KinematicBody2D


onready var stats=$Stats
onready var playerDetectionZone=$PlayerDetectionZone
enum {
	ATTACK,
	DASH,
	IDLE
}
var state=IDLE
var velocity=Vector2.ZERO
var PlayerInNoDamageZone=false
var player
export (String) var rutaJugador
onready var Jugador=get_tree().get_root().get_node(rutaJugador)
export var speed=100
export var direction=1
export (Vector2) var positionAttackLeft=Vector2.ZERO
export (Vector2) var positionAttackRight=Vector2.ZERO
signal dead()

func _ready():
	Jugador.connect("comienzaStunGorgona",self,"estuneado")
	Jugador.connect("acabaStunGorgona",self,"finestuneado")

func _physics_process(delta):
	if playerDetectionZone.can_see_player():
		state=ATTACK
	match state:
			IDLE:
				idle()
			DASH:
				dash(delta)
			ATTACK:
				attack(delta)

func idle():
	$AnimationPlayer.play("IDLEEnemigoAtaca") 
	velocity=Vector2.ZERO


func dash(delta):
	$AnimationPlayer.play("AvanzaEnemigoAtaque")
	velocity.x=(speed*delta*direction)/delta
	velocity.y=0
	velocity=move_and_slide(velocity,Vector2(0,-1))

func attack(delta):
	player=playerDetectionZone.player
	if player!=null:
		$AnimationPlayer.play("AttackEnemigoAtaca")
		velocity.x=(speed*delta*direction)/delta
		velocity.y=0
		velocity=move_and_slide(velocity,Vector2(0,-1))
	#else: 
	#	state=IDLE

func attackFinished():
	$PlayerDetectionZone/CollisionShape2D.set_deferred("disabled",true)
	$TimerAtaque.start()
	change_state()
func direccionMordisco():
	if player.global_position.x <= global_position.x:
		if direction==1:
			scale.x*=-1
			$AnimationPlayer.stop(false)
			yield(get_tree().create_timer(0.4),"timeout")
		direction=-1
	else:
		if direction==-1:
			scale.x*=-1
			$AnimationPlayer.stop(false)
			yield(get_tree().create_timer(0.2),"timeout")
		direction=1

func change_state():
	$Timer.start(1)
	velocity.x=0
	state=IDLE

func _on_Hurtbox_invincibility_started():
	$BlinkAnimation.play("BlinkEnemigoAtaca")

func _on_Hurtbox_invincibility_ended():
	$BlinkAnimation.play("StopBlinkEnemigoAtaca")


func _on_Hurtbox_area_entered(area):
	if !PlayerInNoDamageZone:
		stats.health-=area.damage
		$Hurtbox.start_invincibility(0.4)


func _on_Stats_no_health():
	$Hurtbox.create_hit_effect()
	$TimerAtaque.stop()
	$Timer.stop()
	emit_signal("dead")
	queue_free()


func _on_WallDetector_body_entered(body):
	if body.name=="Limit" || body.name=="Limit2":
		if direction==1:
			direction=-1
			scale.x*=-1
		else:
			direction=1
			scale.x*=-1
		state=IDLE
		$Timer.start(2)


func _on_Timer_timeout():
	if state==IDLE:
		state=DASH


func _on_NoDamageZone_body_entered(body):
	if body.name=="Jugador":
		PlayerInNoDamageZone=true


func _on_NoDamageZone_body_exited(body):
	if body.name=="Jugador":
		PlayerInNoDamageZone=false

func estuneado(cuerpo):
	if self==cuerpo:
		$Sprite.material.shader=load("res://Shaders/Piedra.shader")
		$AnimationPlayer.stop(false)
func finestuneado():
	$Sprite.material.shader=load("res://Shaders/Blink.shader")
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play()


func _on_TimerAtaque_timeout():
	$PlayerDetectionZone/CollisionShape2D.set_deferred("disabled",false)
