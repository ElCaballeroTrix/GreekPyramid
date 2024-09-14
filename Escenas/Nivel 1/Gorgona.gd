extends KinematicBody2D

var velocidad=Vector2.ZERO
var knockback=Vector2.ZERO
onready var stats=$Stats
onready var playerDetectionZone=$PlayerDetectionZone

export var accelaration=300
export var max_speed=50
export var friction=200

enum{
	IDLE,
	WANDER,
	CHASE
}
var state=IDLE
func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,friction*delta)
	knockback=move_and_slide(knockback)
	if is_on_floor():
		$AnimatedSprite.animation="arco"
	match state:
		IDLE:
			velocidad=velocidad.move_toward(Vector2.ZERO,friction*delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player=playerDetectionZone.player
			var direccion=0
			if player!=null:
					direccion=(player.global_position-global_position).normalized()
					velocidad=velocidad.move_toward(direccion*max_speed,accelaration*delta)
					velocidad.y=0
			else: state=IDLE
			$AnimatedSprite.flip_h=velocidad.x>0
	velocidad=move_and_slide(velocidad)

func seek_player():
	if playerDetectionZone.can_see_player():
		state=CHASE

func _on_Hurtbox_area_entered(area):
	knockback=area.knockback_vector*110
	stats.health-=area.damage
	$Hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()

func _on_Hit_Dere_area_entered(area):
		attack()

func attack():
	$AnimatedSprite.animation="petrificacion"
	yield($AnimatedSprite,"animation_finished")
	
func _on_Hit_Izq_area_entered(area):
	attack()

func _on_Hit_Izq_area_exited(area):
	$AnimatedSprite.animation="arco"

func _on_Hit_Dere_area_exited(area):
	$AnimatedSprite.animation="arco"

	
