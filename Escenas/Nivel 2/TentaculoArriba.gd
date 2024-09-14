extends Area2D


onready var animation=$TentaculoAnimationPlayer
var posicionActualAnimacion=0.0
var sePuedeMover=true
var velocidadAnimacion=1.5
var tiempoSinTentaculoCaer=1
var parado=false
export (String) var rutaJugador
onready var Jugador=get_tree().get_root().get_node(rutaJugador)
# Called when the node enters the scene tree for the first time.
func _ready():
	velocidadAnimacion=1.5
	animation.playback_speed=velocidadAnimacion
	Jugador.connect("comienzaStunGorgona",$TentaculoArribaStun,"estuneado")
	Jugador.connect("acabaStunGorgona",$TentaculoArribaStun,"finestuneado")

func _on_TentaculoArriba_body_entered(body):
	if body.name=="Jugador":
		posicionActualAnimacion=animation.current_animation_position
		animation.play("AtacaTentaculo")
		$CollisionShape2D.set_deferred("disabled",true)

func movimientoTentaculo():
	if sePuedeMover:
		animation.assigned_animation="MovimientoTentaculo"
		animation.seek(posicionActualAnimacion)
		animation.play()
		yield(get_tree().create_timer(tiempoSinTentaculoCaer),"timeout")
		$CollisionShape2D.set_deferred("disabled",false)


func _on_Caribdis_sacarTentaculoDeArriba():
	$CollisionShape2D.set_deferred("disabled",true)
	if animation.is_playing():
		if animation.current_animation=="AtacaTentaculo":
			animation.playback_speed=2
			if animation.current_animation_position>=0 && animation.current_animation_position<=2:
				animation.play_backwards("AtacaTentaculo")
			sePuedeMover=false
			yield(get_node("TentaculoAnimationPlayer"),"animation_finished")
			animation.playback_speed=velocidadAnimacion
		sePuedeMover=false
		animation.playback_speed=velocidadAnimacion
		animation.stop()
		animation.play("SeVaElTentaculo")
		yield(get_node("TentaculoAnimationPlayer"),"animation_finished")
		position=Vector2(400,-150)
		posicionActualAnimacion=0.0

func _on_Caribdis_saleTenaculoDeArriba():
	animation.play("SaleElTentaculoEnPantalla")
	sePuedeMover=true

func _on_Caribdis_dead():
	queue_free()

func _on_Hitbox_area_entered(area):
	$Hitbox/CollisionShape2D.set_deferred("disabled",true)
	animation.playback_speed=2

func finAtacar():
	$Hitbox/CollisionShape2D.set_deferred("disabled",false)
	animation.playback_speed=velocidadAnimacion

func estuneado():
	set_process(false)
	$Sprite.material.shader=load("res://Shaders/Piedra.shader")
	if animation.is_playing():
		parado=true
		animation.stop(false)
func finestuneado():
	set_process(true)
	$Sprite.material.shader=load("res://Shaders/Blink.shader")
	if parado:
		animation.play()
		parado=false
