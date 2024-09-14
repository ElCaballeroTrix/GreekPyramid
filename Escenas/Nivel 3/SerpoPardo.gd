extends KinematicBody2D

var velocidad=Vector2.ZERO
var knockback=Vector2.ZERO
onready var stats=$Stats
export var accelaration=400
export var max_speed=300
export var friction=200
onready var Jugador=get_tree().get_root().get_node("Main_Serpopardo/Jugador")
onready var JugadorHurtbox=get_tree().get_root().get_node("Main_Serpopardo/Jugador/Hurtbox")
var Jugador_Encima=false
var Encima=false
var dentroZonaStun=false
var enCambioFase=false
enum{
	IDLE,
	CUELLO,
	CORRER,
	ROCAS, #Pega un grito que empuja al jugador, y salen una rocas del cielo, estas rocas pueden ser empujadas por el jugador
	LANZA, #Usa su cuello para atacar al enemigo desde arriba muy rápido multiples veces
	EXHAUSTED
}
var state=IDLE
var state_previo=IDLE
var state_siguiente=IDLE
var timer=0
var timer2=0
var en_movimiento=0
var animationSpeed=1
signal segundaFase()
signal dead()

func _ready():
	$Sprites/Grito.visible=false
	#changeState()
	Jugador.connect("comienzaStunGorgona",self,"estuneado")
	Jugador.connect("acabaStunGorgona",self,"finestuneado")

func changeState():
	if enCambioFase:
		$AnimacionSerpoPardo.play("CambioFaseSerpoPardo")
	else:
		$AnimacionSerpoPardo.playback_speed=1
		state_previo=state
		var posibleStates
		match state:
			IDLE:
				posibleStates=[CUELLO,CORRER,ROCAS,LANZA]
			CUELLO:
				posibleStates=[IDLE,CORRER,ROCAS,LANZA]
			CORRER:
				posibleStates=[IDLE,CUELLO,ROCAS,LANZA]
			ROCAS:
				posibleStates=[IDLE,CUELLO,CORRER,LANZA]
			LANZA:
				posibleStates=[IDLE,CUELLO,CORRER,ROCAS]
			EXHAUSTED:
				posibleStates=[CUELLO,CORRER,ROCAS,LANZA]
		state=posibleStates[randi()% posibleStates.size()]
		currentState()

func currentState():
	match state:
		IDLE:
			if state_previo==CUELLO || state_previo==LANZA:
				$AnimacionSerpoPardo.play("VueltaEscenario")
				yield(get_node("AnimacionSerpoPardo"),"animation_finished")
			$AnimacionSerpoPardo.playback_speed=animationSpeed
			$AnimacionSerpoPardo.play("IDLE")
		CUELLO:
			if state_previo==LANZA:
				$AudioSerpoPardo.stream=load("res://Sonidos/Jefes/SerpoPardo/CuelloSerpoPardo.wav")
				$AudioSerpoPardo.play()
				yield(get_node("AudioSerpoPardo"),"finished")
#				yield(get_tree().create_timer(2),"timeout")
				cuello()
			else:
				$AnimacionSerpoPardo.play("Salto")
		CORRER:
			if state_previo==CUELLO || state_previo==LANZA:
				$AnimacionSerpoPardo.play("VueltaEscenario")
				yield(get_node("AnimacionSerpoPardo"),"animation_finished")
			$AnimacionSerpoPardo.playback_speed=1.5
			$AnimacionSerpoPardo.play("UTurnSerpopardo")
		ROCAS:
			if state_previo==CUELLO || state_previo==LANZA:
				$AnimacionSerpoPardo.play("VueltaEscenario")
				yield(get_node("AnimacionSerpoPardo"),"animation_finished")
			$Rocas/TimerRocas.start()
			$AnimacionSerpoPardo.playback_speed=2
			$AnimacionSerpoPardo.play("Grito")
		LANZA:
			if state_previo==CUELLO:
				$AudioSerpoPardo.stream=load("res://Sonidos/Jefes/SerpoPardo/LANZASerpoPardo.wav")
				$AudioSerpoPardo.play()
				yield(get_node("AudioSerpoPardo"),"finished")
#				yield(get_tree().create_timer(2),"timeout")
				$TimerLanza.start()
				lanza()
			else:
				$AnimacionSerpoPardo.play("Salto")

func cambiarDireccion():
	$Sprites/SpriteSerpopardo.scale.x=-1*$Sprites/SpriteSerpopardo.scale.x

func finSalto():
	if state==CUELLO:
		cuello()
	else:
		$TimerLanza.start()
		lanza()

func cuello():
	var direccion=["IZQ","DER"]
	var direccionDefinitiva=direccion[randi()% direccion.size()]
	if direccionDefinitiva=="IZQ":
		$AnimacionSerpoPardo.play("Ataque_Cuello_Izq")
	else:
		$AnimacionSerpoPardo.play("Ataque_Cuello_Der")

func lanza():
	$Hurtboxes/HurtboxCuelloLanza.global_position.x=Jugador.position.x
	$Sprites/CuelloLanza.global_position.x=Jugador.position.x
	$Hitboxes/HitboxLanza.global_position.x=Jugador.position.x
	$Colision.global_position.x=Jugador.position.x
	$AnimacionSerpoPardo.play("Lanza")

func _on_TimerLanza_timeout():
	$AnimacionSerpoPardo.stop()
	$Hitboxes/HitboxLanza.position.y=-320
	$Sprites/CuelloLanza.position.y=-320
	$Colision.position.y=-320
	$Hurtboxes/HurtboxCuelloLanza.position.y=-320
	changeState()

func descansoTrasCorrer():
	if !enCambioFase:
		state=EXHAUSTED
		$AnimacionSerpoPardo.play("Cansado")
	else:
		$AnimacionSerpoPardo.playback_speed=1
		changeState()

func cambioFase():
	emit_signal("segundaFase")
#####################################################################################
###############################ROCAS#################################################
#####################################################################################
func rocas():
	#Si eso, solo poner dos boulders cada vez
	var randomBoulder=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14] 
	var boulderChosen=randomBoulder[randi() % randomBoulder.size()]
	randomBoulder.remove(boulderChosen)
	var boulderChosen2=randomBoulder[randi() % randomBoulder.size()]
	if boulderChosen2==14:
		randomBoulder.remove(boulderChosen2-1)
	else: randomBoulder.remove(boulderChosen2)
	var boulderChosen3=randomBoulder[randi() % randomBoulder.size()]
	var escena=load("res://Escenas/ObjetoCaeYEmpujable.tscn")
	var boulder=escena.instance()
	boulder.position=Vector2(boulderChosen*32,-40)
	var boulder2=escena.instance()
	boulder2.position=Vector2(boulderChosen2*32,-40)
	var boulder3=escena.instance()
	boulder3.position=Vector2(boulderChosen3*32,-40)
	$Rocas.add_child(boulder)
	$Rocas.add_child(boulder2)
	$Rocas.add_child(boulder3)

func _on_TimerRocas_timeout():
	rocas()
	$Rocas/TimerRocas.start()

func finalizarRocas():
	$Rocas/TimerRocas.stop()
	$Sprites/Grito/ColisionGrito/CollisionShape2D.set_deferred("disabled",true)
	if !enCambioFase:
		state=IDLE
		state_previo=ROCAS
		currentState()
	else: changeState()
#####################################################################################
func _on_HurtboxCuerpo_area_entered(area):
	if area.name=="HitboxBoulder":
		state=EXHAUSTED
		$Sprites/Grito.visible=false
		$Sprites/Grito2.visible=false
		$Sprites/Grito3.visible=false
		$Sprites/Grito/ColisionGrito/CollisionShape2D.set_deferred("disabled",true)
		$Rocas/TimerRocas.stop()
		$AnimacionSerpoPardo.playback_speed=1
		$AnimacionSerpoPardo.play("Cansado")
	else:
		stats.health-=area.damage
		$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
		$Hurtboxes/HurtboxCuerpo.start_invincibility(0.4)
		if stats.health==12:
			enCambioFase=true

func _on_HurtboxCuelloLanza_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Hurtboxes/HurtboxCuelloLanza.start_invincibility(0.4)
	if stats.health==12:
		enCambioFase=true
func _on_HurtboxCuello_area_entered(area):
	stats.health-=area.damage
	$Health_Boss/ProgressBar.set_bar_value($Health_Boss/ProgressBar.value-1)
	$Hurtboxes/HurtboxCuello.start_invincibility(0.4)
	if stats.health==12:
		enCambioFase=true
func _on_HurtboxCuerpo_invincibility_started():
	$Hurtboxes/HurtboxCuerpo/CollisionPolygon2D.set_deferred("disabled",true)
	$BlinkAnimation.play("BlinkSerpoPardo")
func _on_HurtboxCuerpo_invincibility_ended():
	$Hurtboxes/HurtboxCuerpo/CollisionPolygon2D.set_deferred("disabled",false)
	$BlinkAnimation.play("StopBlinkSerpoPardo")
func _on_HurtboxCuelloLanza_invincibility_started():
	$Hurtboxes/HurtboxCuerpo/CollisionPolygon2D.set_deferred("disabled",true)
	$BlinkAnimation.play("BlinkSerpoPardo")
func _on_HurtboxCuelloLanza_invincibility_ended():
	$Hurtboxes/HurtboxCuerpo/CollisionPolygon2D.set_deferred("disabled",false)
	$BlinkAnimation.play("StopBlinkSerpoPardo")
func _on_HurtboxCuello_invincibility_started():
	$Hurtboxes/HurtboxCuerpo/CollisionPolygon2D.set_deferred("disabled",true)
	$BlinkAnimation.play("BlinkSerpoPardo")
func _on_HurtboxCuello_invincibility_ended():
	$Hurtboxes/HurtboxCuerpo/CollisionPolygon2D.set_deferred("disabled",false)
	$BlinkAnimation.play("StopBlinkSerpoPardo")


func estuneado(cuerpo):
	$AnimacionSerpoPardo.stop(false)
	if state==LANZA:
		$TimerLanza.paused=true
	if state==ROCAS:
		$Rocas/TimerRocas.paused=true
		$Sprites/Grito.visible=false
		$Sprites/Grito2.visible=false
		$Sprites/Grito3.visible=false
	$Sprites/SpriteSerpopardo.material.shader=load("res://Shaders/Piedra.shader")
	$Sprites/CenterContainer2/CuelloAireManchas.material.shader=load("res://Shaders/Piedra.shader")
	$Sprites/CenterContainer2/CuelloAireManchas2.material.shader=load("res://Shaders/Piedra.shader")
	$Sprites/CuelloAire.material.shader=load("res://Shaders/Piedra.shader")
	$Sprites/CenterContainer/CuelloSuelo.material.shader=load("res://Shaders/Piedra.shader")
	$Sprites/CuelloLanza.material.shader=load("res://Shaders/Piedra.shader")

func finestuneado():
	if state==LANZA:
		$TimerLanza.paused=false
	if state==ROCAS:
		$Rocas/TimerRocas.paused=false
		$Sprites/Grito.visible=true
		$Sprites/Grito2.visible=true
		$Sprites/Grito3.visible=true
	$Sprites/SpriteSerpopardo.material.shader=load("res://Shaders/Blink.shader")
	$Sprites/CenterContainer2/CuelloAireManchas.material.shader=load("res://Shaders/Blink.shader")
	$Sprites/CenterContainer2/CuelloAireManchas2.material.shader=load("res://Shaders/Blink.shader")
	$Sprites/CuelloAire.material.shader=load("res://Shaders/Blink.shader")
	$Sprites/CenterContainer/CuelloSuelo.material.shader=load("res://Shaders/Blink.shader")
	$Sprites/CuelloLanza.material.shader=load("res://Shaders/Blink.shader")
	$AnimacionSerpoPardo.play()


func _on_Stats_no_health():
	emit_signal("dead")
