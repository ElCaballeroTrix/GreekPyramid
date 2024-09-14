extends KinematicBody2D


var velocidad=Vector2.ZERO
var knockback=Vector2.ZERO
onready var stats=$Stats
onready var playerDetectionZone=$PlayerDetectionZone
onready var softCollision=$SoftCollision
onready var wanderController=$WanderController

export (String) var sonidoAtaque
export (String) var sonido
export var accelaration=300
export var max_speed=90
export var friction=200
export var wander_target_range=4
var direction=1
var gravity=10
var speed=30
enum{
	IDLE,
	WANDER,
	CHASE
}
var state=CHASE

func _ready():
	state=pick_random_state([IDLE,WANDER])
	var times=[7,8,9,10,12,15,18,20]
	$TimerSonido.start(times[randi()% times.size()])

func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,friction*delta)
	knockback=move_and_slide(knockback)
	if is_on_wall():
		velocidad.y=-4
	match state:
		IDLE:
			velocidad=velocidad.move_toward(Vector2.ZERO,friction*delta)
			seek_player()
			if wanderController.get_time_left()==0:
				update_wander()
		WANDER:
			seek_player()
			if wanderController.get_time_left()==0:
				update_wander()
			accelerate_towards_point(wanderController.target_position,delta)
			if global_position.distance_to(wanderController.target_position)<=wander_target_range:
				update_wander()
		CHASE:
			var player=playerDetectionZone.player
			if player!=null:
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
	$AnimatedSprite.flip_h=velocidad.x<0

func seek_player():
	if playerDetectionZone.can_see_player():
		state=CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	knockback=area.knockback_vector*170
	stats.health-=area.damage
	$Hurtbox.start_invincibility(0.4)

func _on_Stats_no_health():
	$Hurtbox.create_hit_effect()
	queue_free()


func _on_Hitbox_area_entered(area):
	var interferencia=global_position - area.global_position
	knockback.x=sign(interferencia.x)*(accelaration/1.5)
	knockback.y=velocidad.y/1.5
	$AudioStreamPlayer2D.stream=load(sonidoAtaque)
	$AudioStreamPlayer2D.play()


func _on_Hurtbox_invincibility_started():
	$Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$BlinkAnimationPlayer.play("StartBlink")


func _on_Hurtbox_invincibility_ended():
	$Hitbox/CollisionShape2D.set_deferred("disabled",false)
	$BlinkAnimationPlayer.play("StopBlinkVolador")



func _on_Area2D_body_entered(body):
	if body.name=="TileMap":
		knockback=Vector2.ZERO


func _on_TimerSonido_timeout():
	$AudioStreamPlayer2D.stream=load(sonido)
	$AudioStreamPlayer2D.play()
	var times=[7,8,9,10,12,15,18,20]
	$TimerSonido.start(times[randi()% times.size()])
