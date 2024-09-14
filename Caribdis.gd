extends KinematicBody2D


onready var stats=$Stats
onready var animation=$AnimationPlayer
onready var playerDetectionZone=$PlayerDetectionZone
onready var tentaculoArribaHurtbox=get_tree().get_root().get_node("Main_Caribdis/TentaculoArriba/HurtboxTentaculoArriba")
onready var tentaculoArriba=get_tree().get_root().get_node("Main_Caribdis/TentaculoArriba")
onready var tentaculoArribaAnimation=get_tree().get_root().get_node("Main_Caribdis/TentaculoArriba/TentaculoAnimationPlayer")
onready var tentaculo1=$TentaculosAbajo/TentaculoAbajo1/Animation
onready var tentaculo2=$TentaculosAbajo/TentaculoAbajo2/Animation
onready var tentaculo3=$TentaculosAbajo/TentaculoAbajo3/Animation
onready var tentaculos=[tentaculo1,tentaculo2,tentaculo3]
onready var tentaculo1Sprite=$TentaculosAbajo/TentaculoAbajo1/Sprite
onready var tentaculo2Sprite=$TentaculosAbajo/TentaculoAbajo2/Sprite
onready var tentaculo3Sprite=$TentaculosAbajo/TentaculoAbajo3/Sprite
onready var rayo1=get_tree().get_root().get_node("Main_Caribdis/Lighting")
onready var rayo2=get_tree().get_root().get_node("Main_Caribdis/Lighting2")
onready var rayo3=get_tree().get_root().get_node("Main_Caribdis/Lighting3")
onready var rayo1Timer=get_tree().get_root().get_node("Main_Caribdis/Lighting/Timer")
onready var rayo2Timer=get_tree().get_root().get_node("Main_Caribdis/Lighting2/Timer")
onready var rayo3Timer=get_tree().get_root().get_node("Main_Caribdis/Lighting3/Timer")
onready var barco1=get_tree().get_root().get_node("Main_Caribdis/Barquitos/Barquito/AnimationPlayer2")
onready var barco2=get_tree().get_root().get_node("Main_Caribdis/Barquitos/Barquito2/AnimationPlayer2")
onready var barco3=get_tree().get_root().get_node("Main_Caribdis/Barquitos/Barquito3/AnimationPlayer2")
export (String) var rutaJugador
onready var Jugador=get_tree().get_root().get_node(rutaJugador)
enum{
	OLAS,
	MORDISCO,
	TENTACULOS,
	CAMBIO_FASE,
	MORDISCOINDIVIDUAL
}
var state=OLAS
var estadoTentaculosEnAccion=false
var tiempoBurbujas=3
var enEstadoOLAS=false
var enZonaDeMordiscos=false
var velocidadAnimacion=1
var tentaculo1Parado=false
var tentaculo2Parado=false
var tentaculo3Parado=false
var precacucionSiTentaculoArribaSeQuedaCuandoNoEsDebido=false
var enMordisconIndividual=false
signal saleTenaculoDeArriba()
signal sacarTentaculoDeArriba()
signal segundaFase()
signal dead()
func _ready():
	$Sprites/Sprite.visible=true
	$Sprites/SpriteDosBocas.visible=false
	$Sprites/Burbuja.visible=false
	$Light2D.energy=0
	animation.playback_speed=1
	$Hitboxes/Hitbox/CollisionShape2D.set_deferred("disabled",false)
	$Hitboxes/Hitbox2/CollisionShape2D.set_deferred("disabled",false)
	$Hitboxes/Hitbox3/CollisionShape2D.set_deferred("disabled",true)
	$Hitboxes/Hitbox4/CollisionShape2D.set_deferred("disabled",true)
	$Cuerpo/HurtboxMedio/CollisionShape2D.set_deferred("disabled",false)
	$Cuerpo/HurtboxMediano2Bocas/CollisionShape2D.set_deferred("disabled",true)
	Jugador.connect("comienzaStunGorgona",self,"estuneado")
	Jugador.connect("acabaStunGorgona",self,"finestuneado")
	Jugador.connect("comienzaStunGorgona",$TentaculosAbajo/TentaculoAbajo1,"estuneado")
	Jugador.connect("acabaStunGorgona",$TentaculosAbajo/TentaculoAbajo1,"finestuneado")
	Jugador.connect("comienzaStunGorgona",$TentaculosAbajo/TentaculoAbajo2,"estuneado")
	Jugador.connect("acabaStunGorgona",$TentaculosAbajo/TentaculoAbajo2,"finestuneado")
	Jugador.connect("comienzaStunGorgona",$TentaculosAbajo/TentaculoAbajo3,"estuneado")
	Jugador.connect("acabaStunGorgona",$TentaculosAbajo/TentaculoAbajo3,"finestuneado")

func _physics_process(delta):
	match state:
		OLAS:
			olas()
		MORDISCO:
			mordisco()
		TENTACULOS:
			if !estadoTentaculosEnAccion:
				tentaculos()
		CAMBIO_FASE:
			velocidadAnimacion=1.5
		MORDISCOINDIVIDUAL:
			mordiscoIndividual()

func olas():
	if !enEstadoOLAS:
		animation.play("IdleCaribdis")
		enEstadoOLAS=true

func _on_TimerBurbuja_timeout():
	crearBurbujas()
	$TimerBurbuja.start(tiempoBurbujas)

func crearBurbujas():
	$Sprites/Burbuja.visible=true
	$Sprites/Burbuja.frame=0
	$AudioCaribdis.stream=load("res://Sonidos/Jefes/CreacionBurbuja.wav")
	$AudioCaribdis.play()
	$Sprites/Burbuja.play()
	yield(get_node("Sprites/Burbuja"),"animation_finished")
	$Sprites/Burbuja.visible=false
	var player=playerDetectionZone.player
	if player!=null:
		var escena=load("res://Escenas/ProyectilHaciaJugador.tscn")
		var proyectil=escena.instance()
		var positionFire=Vector2(472,136)
		proyectil.direccion=positionFire.direction_to(player.global_position)
		proyectil.rotationBala=player.rotation-90
		proyectil.sprite="WaterShot"
		proyectil.x_speed=500
		proyectil.sonido="res://Sonidos/Jefes/CaribdisBurbujas.wav"
		add_child(proyectil)
		proyectil.global_position=positionFire

func _on_Timer_timeout():
	$TimerBurbuja.stop()
	change_state()
#################Mordiscos#################
func _on_ZonaMordiscoBarco_body_entered(body):
	if state==OLAS:
		enZonaDeMordiscos=true

func _on_TimerZonaMordisco_timeout():
	if state==OLAS and enZonaDeMordiscos:
		animation.playback_speed=2
		emit_signal("sacarTentaculoDeArriba")
		$Timer.stop()
		$TimerBurbuja.stop()
		state=MORDISCOINDIVIDUAL
	enZonaDeMordiscos=false

func _on_ZonaMordiscoBarco_body_exited(body):
	enZonaDeMordiscos=false
	$ZonaMordiscoBarco/TimerZonaMordisco.stop()

func mordiscoIndividual():
	if !enMordisconIndividual:
		animation.play("MordiscoIndividual")
		enMordisconIndividual=true
func mordisco():
	animation.play("Mordisco")
	if tentaculoArriba.position.y!=-150 and !precacucionSiTentaculoArribaSeQuedaCuandoNoEsDebido:
		precacucionSiTentaculoArribaSeQuedaCuandoNoEsDebido=true
		emit_signal("sacarTentaculoDeArriba")
##############################
func tentaculos():
	animation.play("IdleCaribdis")
	estadoTentaculosEnAccion=true
	yield(get_tree().create_timer(1),"timeout")
	var tentaculoQueSalePrimero=[0,1,2,3]
	var primertentaculo=tentaculoQueSalePrimero[randi()% tentaculoQueSalePrimero.size()]
	var segundotentaculo
	match primertentaculo:
		0:
			var tentaculoQueSaleSegundo=[1,2]
			segundotentaculo=tentaculoQueSaleSegundo[randi()% tentaculoQueSaleSegundo.size()]
		1:
			var tentaculoQueSaleSegundo=[0,2]
			segundotentaculo=tentaculoQueSaleSegundo[randi()% tentaculoQueSaleSegundo.size()]
		2:
			var tentaculoQueSaleSegundo=[0,1]
			segundotentaculo=tentaculoQueSaleSegundo[randi()% tentaculoQueSaleSegundo.size()]
	if primertentaculo!=3:
		rayosRecorrido(primertentaculo,segundotentaculo)
		yield(get_tree().create_timer(1.5),"timeout")
		tentaculos[primertentaculo].play("TentaculoAbajoAtaca")
		tentaculos[segundotentaculo].play("TentaculoAbajoAtaca")
	else:
		tresRayosRecorridos()
		yield(get_tree().create_timer(1.5),"timeout")
		tentaculos[0].play("TentaculoAbajoAtaca")
		tentaculos[1].play("TentaculoAbajoAtaca")
		tentaculos[2].play("TentaculoAbajoAtaca")
	$TimerTentaculos.start()

func rayosRecorrido(primero,segundo):
	if primero==0 && segundo==1:
		rayo1.x_axis_left=160
		rayo2.x_axis_left=272
	elif primero==0 && segundo==2:
		rayo1.x_axis_left=160
		rayo2.x_axis_left=392
	elif primero==1 && segundo==0:
		rayo1.x_axis_left=160
		rayo2.x_axis_left=272
	elif primero==1 && segundo==2:
		rayo1.x_axis_left=272
		rayo2.x_axis_left=392
	elif primero==2 && segundo==0:
		rayo1.x_axis_left=160
		rayo2.x_axis_left=392
	elif primero==2 && segundo==1:
		rayo1.x_axis_left=272
		rayo2.x_axis_left=392
	rayo1Timer.start(0.1)
	rayo2Timer.start(0.1)

func tresRayosRecorridos():
	rayo1.x_axis_left=160
	rayo2.x_axis_left=392
	rayo3.x_axis_left=272
	rayo1Timer.start(0.1)
	rayo2Timer.start(0.1)
	rayo3Timer.start(0.1)

func _on_TimerTentaculos_timeout():
	$TimerTentaculos.stop()
	change_state()

func change_state():
	estadoTentaculosEnAccion=false
	var posibleStates
	match state:
		OLAS:
			posibleStates=[MORDISCO,TENTACULOS]
		MORDISCO:
			precacucionSiTentaculoArribaSeQuedaCuandoNoEsDebido=false
			posibleStates=[OLAS,TENTACULOS]
		TENTACULOS:
			posibleStates=[OLAS,TENTACULOS,MORDISCO]
		CAMBIO_FASE:
			posibleStates=[CAMBIO_FASE]
		MORDISCOINDIVIDUAL:
			animation.playback_speed=velocidadAnimacion
			posibleStates=[OLAS,MORDISCO,TENTACULOS]
			if tentaculoArribaAnimation.current_animation=="SeVaElTentaculo":
				yield(tentaculoArribaAnimation,"animation_finished")
			enMordisconIndividual=false
	var nextState=posibleStates[randi()% posibleStates.size()]
	if nextState==OLAS:
		emit_signal("saleTenaculoDeArriba")
		$TimerBurbuja.start(tiempoBurbujas)
		$Timer.start()
	elif state==OLAS && (nextState==TENTACULOS || nextState==MORDISCO):
		emit_signal("sacarTentaculoDeArriba")
	state=nextState
	enEstadoOLAS=false

func _on_Stats_no_health():
	$Cuerpo/HurtBoxAbajo.create_hit_effect()
	$Cuerpo/HurtboxArriba.create_hit_effect()
	$Cuerpo/HurtboxMedio.create_hit_effect()
	emit_signal("dead")

###############Hurtboxes######################################
func _on_HurtBoxAbajo_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Cuerpo/HurtBoxAbajo.start_invincibility(0.4)
	$Cuerpo/HurtboxArriba.start_invincibility(0.4)
	$Cuerpo/HurtboxMedio.start_invincibility(0.4)
	tentaculoArribaHurtbox.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo1/HurtboxTentaculo1.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo2/HurtboxTentaculo2.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo3/HurtboxTentaculo3.start_invincibility(0.4)
	if enZonaDeMordiscos and $ZonaMordiscoBarco/TimerZonaMordisco.is_stopped():
		$ZonaMordiscoBarco/TimerZonaMordisco.start()
	if stats.health==10 :
		emit_signal("segundaFase")


func _on_HurtboxArriba_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Cuerpo/HurtBoxAbajo.start_invincibility(0.4)
	$Cuerpo/HurtboxArriba.start_invincibility(0.4)
	$Cuerpo/HurtboxMedio.start_invincibility(0.4)
	tentaculoArribaHurtbox.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo1/HurtboxTentaculo1.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo2/HurtboxTentaculo2.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo3/HurtboxTentaculo3.start_invincibility(0.4)
	if stats.health==10 :
		emit_signal("segundaFase")


func _on_HurtboxMedio_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Cuerpo/HurtBoxAbajo.start_invincibility(0.4)
	$Cuerpo/HurtboxArriba.start_invincibility(0.4)
	$Cuerpo/HurtboxMedio.start_invincibility(0.4)
	tentaculoArribaHurtbox.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo1/HurtboxTentaculo1.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo2/HurtboxTentaculo2.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo3/HurtboxTentaculo3.start_invincibility(0.4)
	if stats.health==10 :
		emit_signal("segundaFase")


func _on_HurtboxTentaculoArriba_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Cuerpo/HurtBoxAbajo.start_invincibility(0.4)
	$Cuerpo/HurtboxArriba.start_invincibility(0.4)
	$Cuerpo/HurtboxMedio.start_invincibility(0.4)
	tentaculoArribaHurtbox.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo1/HurtboxTentaculo1.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo2/HurtboxTentaculo2.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo3/HurtboxTentaculo3.start_invincibility(0.4)
	if stats.health==10 :
		emit_signal("segundaFase")

func _on_HurtboxTentaculo1_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Cuerpo/HurtBoxAbajo.start_invincibility(0.4)
	$Cuerpo/HurtboxArriba.start_invincibility(0.4)
	$Cuerpo/HurtboxMedio.start_invincibility(0.4)
	tentaculoArribaHurtbox.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo1/HurtboxTentaculo1.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo2/HurtboxTentaculo2.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo3/HurtboxTentaculo3.start_invincibility(0.4)
	if stats.health==10 :
		emit_signal("segundaFase")

func _on_HurtboxTentaculo2_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Cuerpo/HurtBoxAbajo.start_invincibility(0.4)
	$Cuerpo/HurtboxArriba.start_invincibility(0.4)
	$Cuerpo/HurtboxMedio.start_invincibility(0.4)
	tentaculoArribaHurtbox.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo1/HurtboxTentaculo1.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo2/HurtboxTentaculo2.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo3/HurtboxTentaculo3.start_invincibility(0.4)
	if stats.health==10 :
		emit_signal("segundaFase")

func _on_HurtboxTentaculo3_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Cuerpo/HurtBoxAbajo.start_invincibility(0.4)
	$Cuerpo/HurtboxArriba.start_invincibility(0.4)
	$Cuerpo/HurtboxMedio.start_invincibility(0.4)
	tentaculoArribaHurtbox.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo1/HurtboxTentaculo1.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo2/HurtboxTentaculo2.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo3/HurtboxTentaculo3.start_invincibility(0.4)
	if stats.health==10 :
		emit_signal("segundaFase")

func _on_HurtboxMediano2Bocas_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Cuerpo/HurtBoxAbajo.start_invincibility(0.4)
	$Cuerpo/HurtboxArriba.start_invincibility(0.4)
	$Cuerpo/HurtboxMediano2Bocas.start_invincibility(0.4)
	tentaculoArribaHurtbox.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo1/HurtboxTentaculo1.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo2/HurtboxTentaculo2.start_invincibility(0.4)
	$TentaculosAbajo/TentaculoAbajo3/HurtboxTentaculo3.start_invincibility(0.4)
	if stats.health==10 :
		emit_signal("segundaFase")
#####################BLINK############################################
func _on_Hurtbox_invincibility_started():
	$BlinkAnimation.play("BlinkCaribdis")

func _on_Hurtbox_invincibility_ended():
	$BlinkAnimation.play("StopBlinkCaribdis")

func _on_HurtboxTentaculoArriba_invincibility_started():
	$BlinkAnimation.play("BlinkCaribdis")


func _on_HurtboxTentaculoArriba_invincibility_ended():
	$BlinkAnimation.play("StopBlinkCaribdis")


func _on_HurtboxArriba_invincibility_started():
	$BlinkAnimation.play("BlinkCaribdis")


func _on_HurtboxArriba_invincibility_ended():
	$BlinkAnimation.play("StopBlinkCaribdis")


func _on_HurtboxMedio_invincibility_started():
	$BlinkAnimation.play("BlinkCaribdis")


func _on_HurtboxMedio_invincibility_ended():
	$BlinkAnimation.play("StopBlinkCaribdis")

func _on_HurtboxTentaculo1_invincibility_started():
	$BlinkAnimation.play("BlinkCaribdis")


func _on_HurtboxTentaculo1_invincibility_ended():
	$BlinkAnimation.play("StopBlinkCaribdis")


func _on_HurtboxTentaculo2_invincibility_started():
	$BlinkAnimation.play("BlinkCaribdis")


func _on_HurtboxTentaculo2_invincibility_ended():
	$BlinkAnimation.play("StopBlinkCaribdis")

func _on_HurtboxTentaculo3_invincibility_started():
	$BlinkAnimation.play("BlinkCaribdis")


func _on_HurtboxTentaculo3_invincibility_ended():
	$BlinkAnimation.play("StopBlinkCaribdis")


func _on_HurtboxMediano2Bocas_invincibility_started():
	$BlinkAnimation.play("BlinkCaribdis")


func _on_HurtboxMediano2Bocas_invincibility_ended():
	$BlinkAnimation.play("StopBlinkCaribdis")

func estuneado(cuerpo):
	animation.stop(false)
	$Timer.paused=true
	$TimerBurbuja.paused=true
	$ZonaMordiscoBarco/TimerZonaMordisco.paused=true
	$Sprites/Sprite.material.shader=load("res://Shaders/Piedra.shader")
	$Sprites/Sprite2.material.shader=load("res://Shaders/Piedra.shader")
	$Sprites/SpriteDosBocas.material.shader=load("res://Shaders/Piedra.shader")
	tentaculoArriba.estuneado()
	if $TentaculosAbajo/TentaculoAbajo1/Animation.is_playing():
		tentaculo1Parado=true
		tentaculo1Sprite.material.shader=load("res://Shaders/Piedra.shader")
		$TentaculosAbajo/TentaculoAbajo1/Animation.stop(false) 
	if $TentaculosAbajo/TentaculoAbajo2/Animation.is_playing():
		tentaculo2Parado=true
		tentaculo2Sprite.material.shader=load("res://Shaders/Piedra.shader")
		$TentaculosAbajo/TentaculoAbajo2/Animation.stop(false)
	if $TentaculosAbajo/TentaculoAbajo3/Animation.is_playing():
		tentaculo3Parado=true
		tentaculo3Sprite.material.shader=load("res://Shaders/Piedra.shader")
		$TentaculosAbajo/TentaculoAbajo3/Animation.stop(false)
	if state==MORDISCO:
		barco1.stop(false)
		barco2.stop(false)
		barco3.stop(false)

func finestuneado():
	$Timer.paused=false
	$TimerBurbuja.paused=false
	$ZonaMordiscoBarco/TimerZonaMordisco.paused=false
	$Sprites/Sprite.material.shader=load("res://Shaders/Blink.shader")
	$Sprites/Sprite2.material.shader=load("res://Shaders/Blink.shader")
	$Sprites/SpriteDosBocas.material.shader=load("res://Shaders/Blink.shader")
	tentaculoArriba.finestuneado()
	animation.play()
	if velocidadAnimacion==1.5:
		$TentaculosAbajo/TentaculoAbajo1/Animation.play()
		$TentaculosAbajo/TentaculoAbajo2/Animation.play()
		$TentaculosAbajo/TentaculoAbajo3/Animation.play()
	if tentaculo1Parado:
		tentaculo1Parado=false
		tentaculo1Sprite.material.shader=load("res://Shaders/Blink.shader")
		$TentaculosAbajo/TentaculoAbajo1/Animation.play()
	if tentaculo2Parado:
		tentaculo2Parado=false
		tentaculo2Sprite.material.shader=load("res://Shaders/Blink.shader")
		$TentaculosAbajo/TentaculoAbajo2/Animation.play()
	if tentaculo3Parado:
		tentaculo3Parado=false
		tentaculo3Sprite.material.shader=load("res://Shaders/Blink.shader")
		$TentaculosAbajo/TentaculoAbajo3/Animation.play()
	if state==MORDISCO:
		barco1.play()
		barco2.play()
		barco3.play()
