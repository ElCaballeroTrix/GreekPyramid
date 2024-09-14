extends KinematicBody2D


export var positionFireLeft=Vector2.ZERO
export var positionFireRight=Vector2.ZERO
export (String) var rutaJugador
export (String) var proyectilSprite
onready var Jugador=get_tree().get_root().get_node(rutaJugador)
onready var playerDetectionZone=$PlayerDetectionZone
onready var stats=$Stats

func _ready():
	Jugador.connect("comienzaStunGorgona",self,"estuneado")
	Jugador.connect("acabaStunGorgona",self,"finestuneado")


func escupir():
	var player=playerDetectionZone.player
	var aimingPosition
	if player != null:
		aimingPosition=player.global_position
		aimingPosition.y+=19
	else: 
		aimingPosition= global_position
		aimingPosition.x-=$PlayerDetectionZone/CollisionShape2D.shape.get("radius")/2
	var positionFire
	if aimingPosition.x > global_position.x:
		$Sprite.flip_h=true
		positionFire=positionFireRight
	else:
		$Sprite.flip_h=false
		positionFire=positionFireLeft
	var escena=load("res://Escenas/ProyectilConCurva.tscn")
	var proyectil=escena.instance()
	proyectil.direccion=aimingPosition
	proyectil.sprite=proyectilSprite
	add_child(proyectil)
	proyectil.global_position=positionFire


func _on_Stats_no_health():
	$Hurtbox.create_hit_effect()
	queue_free()

func _on_Hurtbox_invincibility_started():
	$BlinkAnimation.play("BlinkAnimationEnemigoEscupe")


func _on_Hurtbox_invincibility_ended():
	$BlinkAnimation.play("StopBlinkAnimationEnemigoEscupe")

func _on_Hurtbox_area_entered(area):
	stats.health-=area.damage
	$Hurtbox.start_invincibility(0.4)

func estuneado(cuerpo):
	if self==cuerpo:
		$Sprite.material.shader=load("res://Shaders/Piedra.shader")
		$AnimationPlayer.stop(false)
func finestuneado():
	$Sprite.material.shader=load("res://Shaders/Blink.shader")
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play()
