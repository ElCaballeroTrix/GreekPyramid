extends Node2D

var salioDelAgua=true
var entroEnAgua=false
var muriendo=false
var numeroDialogosPoseidon=0
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.nombre_audio_suelo="Madera"
	Global.nombre_carpeta_suelo="Madera"
	$Jugador.set_physics_process(false)
	$Caribdis.set_physics_process(false)
	Global.stop_song()
	var shapeHurtboxAbajo=RectangleShape2D.new()
	shapeHurtboxAbajo.extents=Vector2(20,40)
	$Caribdis/Cuerpo/HurtBoxAbajo/CollisionShape2D.shape=shapeHurtboxAbajo
	$Extrana/CanvasLayer/Dialogo.connect("pageNumber",self,"poseidonTalks")
	$Pegaso.set_physics_process(false)

func gritoCaribdis():
	$TileMap.visible=false
	#GritoDeCaribdis
	$Caribdis/AudioCaribdis.stream=load("res://Sonidos/Jefes/CaribdisRugido.wav")
	$Caribdis/AudioCaribdis.play()
	$ScreenShake.screen_shake(3,10,100)

func fin_inicio():
	Global.play_song("res://Sonidos/Musica/CaribdisBossFight.wav")
	$Caribdis/Health_Boss/ProgressBar.visible=true
	$Jugador/CanvasLayer/HealthUI.visible=true
	$Jugador.set_physics_process(true)
	$Caribdis.set_physics_process(true)
	$Caribdis/Timer.start()
	$Caribdis/TimerBurbuja.start(1)
	$TentaculoArriba/TentaculoAnimationPlayer.play("SaleElTentaculoEnPantalla")
#############################################
func _on_Jugador_teletransporte_muerto():
	var target_stage="res://Escenas/Nivel 2/Nivel2.tscn"
	get_tree().change_scene(target_stage)

func _on_PauseMenu_reinicio():
	PlayerStats.health=PlayerStats.max_health
	$Jugador/Sprite.material.set('shader_param/active',false)
	var target_stage="res://Escenas/Nivel 2/Nivel2.tscn"
	get_tree().change_scene(target_stage)

func _on_TentaculoAbajo1_body_entered(body):
	$Caribdis/AudioAgua.stream=load("res://Sonidos/Nivel2/BarcaRota.wav")
	$Caribdis/AudioAgua.play()
	yield(get_node("Caribdis/AudioAgua"),"finished")
	$Barquitos/Barquito/Barco.visible=false
	$Barquitos/Barquito/AnimationPlayer.play("ArribaBarquito")
	yield(get_tree().create_timer(2),"timeout")
	$Barquitos/Barquito/Barco.visible=true
	$Barquitos/Barquito/AnimationPlayer.play_backwards("ArribaBarquito")

func _on_TentaculoAbajo2_body_entered(body):
	$Caribdis/AudioAgua.stream=load("res://Sonidos/Nivel2/BarcaRota.wav")
	$Caribdis/AudioAgua.play()
	yield(get_node("Caribdis/AudioAgua"),"finished")
	$Barquitos/Barquito2/Barco.visible=false
	$Barquitos/Barquito2/AnimationPlayer.play("ArribaBarquito")
	yield(get_tree().create_timer(2),"timeout")
	$Barquitos/Barquito2/Barco.visible=true
	$Barquitos/Barquito2/AnimationPlayer.play_backwards("ArribaBarquito")
	$Barquitos/Barquito2/AnimationPlayer2.play()

func _on_TentaculoAbajo3_body_entered(body):
	$Caribdis/AudioAgua.stream=load("res://Sonidos/Nivel2/BarcaRota.wav")
	$Caribdis/AudioAgua.play()
	yield(get_node("Caribdis/AudioAgua"),"finished")
	$Barquitos/Barquito3/Barco.visible=false
	$Barquitos/Barquito3/AnimationPlayer.play("ArribaBarquito")
	yield(get_tree().create_timer(2),"timeout")
	$Barquitos/Barquito3/Barco.visible=true
	$Barquitos/Barquito3/AnimationPlayer.play_backwards("ArribaBarquito")

func subeTresBarcosDestruidos():
	$Barquitos/Barquito2/Barco.visible=true
	$Barquitos/Barquito3/Barco.visible=true
	$Barquitos/Barquito2/AnimationPlayer.play_backwards("ArribaBarquito")
	$Barquitos/Barquito3/AnimationPlayer.play_backwards("ArribaBarquito")
	$Barquitos/Barquito4/AnimationPlayer.play_backwards("ArribaBarquito")

func subeUnbarcoEnMordiscoIndividual():
	$Barquitos/Barquito3/Barco.visible=true
	$Barquitos/Barquito3/AnimationPlayer.play_backwards("ArribaBarquito")

#############Empuje###################
func _on_Timer_Empuje_timeout():
	$Jugador/Colision.set_deferred("disabled",false)
	$Jugador.emit_signal("fin_de_empuje_boss")

func _on_HitboxTentaculo3_area_entered(area):
	#Quitar El Empuje y dejar los barcos, creo que sera lo mejor
	$Caribdis/TentaculosAbajo/TentaculoAbajo3/HitboxTentaculo3/CollisionShape2D.set_deferred("disabled",true)
	yield(get_tree().create_timer(0.1),"timeout")
	$Jugador.emit_signal("luchando_con_boss",10,-1.5,-1)
	$Timer_Empuje.start()


func _on_HitboxTentaculo2_area_entered(area):
	$Caribdis/TentaculosAbajo/TentaculoAbajo2/HitboxTentaculo2/CollisionShape2D.set_deferred("disabled",true)
	yield(get_tree().create_timer(0.1),"timeout")
	$Jugador.emit_signal("luchando_con_boss",10,-1.5,-1)
	$Timer_Empuje.start()


func _on_HitboxTentaculo1_area_entered(area):
	$Caribdis/TentaculosAbajo/TentaculoAbajo1/HitboxTentaculo1/CollisionShape2D.set_deferred("disabled",true)
	yield(get_tree().create_timer(0.1),"timeout")
	$Jugador.emit_signal("luchando_con_boss",10,-1.5,-1)
	$Timer_Empuje.start()

func _on_Agua_body_entered(body):
	body.knockback=Vector2.ZERO
	body.state=9 #Estado de Brinco
	yield(get_tree().create_timer(0.1),"timeout")
	$Jugador/Colision.set_deferred("disabled",true)
	$Jugador.emit_signal("luchando_con_boss",1,-1.5,-1)
	$Timer_Empuje.start()


func _on_Caribdis_segundaFase():
	#Jugador no reciba daño mientras se cambia de Fase
	$Jugador.Hit.set_deferred("disabled",true)
	$Jugador/Hurtbox/CollisionShape2D.set_deferred("disabled",true)
	$Jugador/Hurt_rodar/CollisionShape2D.set_deferred("disabled",true)
	$Jugador/AnimationPlayer.play("Idle")
	$Jugador.direccion=1
	$Jugador.knockback=Vector2.ZERO
	$Jugador.state=0
	$Jugador.set_physics_process(false)
	$AnimationPlayer.play("CaribdisCambiaDeFase")
	yield(get_node("AnimationPlayer"),"animation_finished")
	$Jugador.global_position=Vector2(34,224.5)
	#Hacemos que el parallax vaya más lento, sino, se acelera muchisimo
	$ParallaxBackground.set_process(false)
	#Dependiendo del estado en el que estaba Caribdis, tendra 
	#que volver a su lugar inicial sin tentaculos de por medio
	if $Caribdis/AnimationPlayer.current_animation=="Mordisco":
		$Caribdis/AnimationPlayer.playback_speed=3
		$Caribdis/AnimationPlayer.play_backwards("Mordisco")
		yield(get_node("Caribdis/AnimationPlayer"),"animation_finished")
	elif $Caribdis/AnimationPlayer.current_animation=="MordiscoIndividual":
		$Caribdis/AnimationPlayer.playback_speed=3
		$Caribdis/AnimationPlayer.play_backwards("MordiscoIndividual")
		yield(get_node("Caribdis/AnimationPlayer"),"animation_finished")
	elif $Caribdis.state==0:
		$Caribdis/Timer.stop()
		$Caribdis/TimerBurbuja.stop()
		$Caribdis.emit_signal("sacarTentaculoDeArriba")
		if $Caribdis.has_node("ProyectilHaciaJugador"):
			$Caribdis/ProyectilHaciaJugador.queue_free()
	elif $Caribdis.state==2:
		$Caribdis/TimerTentaculos.stop()
		$Caribdis/TentaculosAbajo/TentaculoAbajo1/Animation.playback_speed=3
		$Caribdis/TentaculosAbajo/TentaculoAbajo1/Animation.play_backwards("TentaculoAbajoAtaca")
		$Caribdis/TentaculosAbajo/TentaculoAbajo2/Animation.playback_speed=3
		$Caribdis/TentaculosAbajo/TentaculoAbajo2/Animation.play_backwards("TentaculoAbajoAtaca")
		$Caribdis/TentaculosAbajo/TentaculoAbajo3/Animation.playback_speed=3
		$Caribdis/TentaculosAbajo/TentaculoAbajo3/Animation.play_backwards("TentaculoAbajoAtaca")
		$Caribdis.estadoTentaculosEnAccion=false
	$Barquitos/Barquito/AnimationPlayer.play_backwards("ArribaBarquito")
	$Barquitos/Barquito2/AnimationPlayer.play_backwards("ArribaBarquito")
	$Barquitos/Barquito3/AnimationPlayer.play_backwards("ArribaBarquito")
	#Ponemos el estado 3, el cual no hace nada y se ejecuta la animación de cambio de Fase
	$Caribdis.enMordisconIndividual=false
	$Caribdis/ZonaMordiscoBarco/TimerZonaMordisco.stop()
	$Caribdis.state=3
	$Caribdis/AnimationPlayer.playback_speed=1
	$Caribdis/AnimationPlayer.play("CambiodeFase") 
	$Caribdis.set_physics_process(false)
	$Caribdis/Sprites/Sprite.visible=false
	$Caribdis/Sprites/SpriteDosBocas.visible=true
	yield(get_node("Caribdis/AnimationPlayer"),"animation_finished")
	$ParallaxBackground.set_process(true)
	#Aumentamos la dificultad con ataques más rápidos
	$Caribdis/AnimationPlayer.playback_speed=1.5
	$Caribdis/TentaculosAbajo/TentaculoAbajo1/Animation.playback_speed=1.5
	$Caribdis/TentaculosAbajo/TentaculoAbajo2/Animation.playback_speed=1.5
	$Caribdis/TentaculosAbajo/TentaculoAbajo3/Animation.playback_speed=1.5
	$TentaculoArriba/TentaculoAnimationPlayer.playback_speed=1.5
	$TentaculoArriba.velocidadAnimacion=1.5
	$TentaculoArriba.tiempoSinTentaculoCaer=1
	$Caribdis.tiempoBurbujas=2
	#Desactivamos las colisiones del Caribidis de la primera fase,
	#y activamos las de la segunda
	$Caribdis/Hitboxes/Hitbox/CollisionShape2D.set_deferred("disabled",true)
	$Caribdis/Hitboxes/Hitbox2/CollisionShape2D.set_deferred("disabled",true)
	$Caribdis/Hitboxes/Hitbox3/CollisionShape2D.set_deferred("disabled",false)
	$Caribdis/Hitboxes/Hitbox4/CollisionShape2D.set_deferred("disabled",false)
	$Caribdis/Cuerpo/HurtboxMedio/CollisionShape2D.set_deferred("disabled",true)
	$Caribdis/Cuerpo/HurtboxMediano2Bocas/CollisionShape2D.set_deferred("disabled",false)
	var shapeHurtboxAbajo=RectangleShape2D.new()
	shapeHurtboxAbajo.extents=Vector2(25,40)
	$Caribdis/Cuerpo/HurtBoxAbajo/CollisionShape2D.shape=shapeHurtboxAbajo
	#Empieza la segunda fase
	#Llamamos a cambioFaseMoverJugador en el segundo 8 de la animación
	$Caribdis.set_physics_process(true)
	$Caribdis.emit_signal("saleTenaculoDeArriba")
	$Caribdis/Timer.start()
	$Caribdis/TimerBurbuja.start(2)
	$Caribdis.state=0


func cambioFaseMoverJugador():
	#Si no, cambiar posicion en el cambio de fase del animation de caribids
	$Jugador.set_physics_process(true)
	$Jugador/Hurtbox/CollisionShape2D.set_deferred("disabled",false)
	$Jugador/Hurt_rodar/CollisionShape2D.set_deferred("disabled",false)

func _on_Caribdis_dead():
	muriendo=true
	$Caribdis.state=0
	$Jugador/Hurtbox/CollisionShape2D.set_deferred("disabled",true)
	$Jugador/Hurt_rodar/CollisionShape2D.set_deferred("disabled",true)
	$Jugador/CanvasLayer/HealthUI.visible=false
	$Caribdis/AnimationPlayer.stop()
	pararBarcos()
	$Barquitos/Barquito/Barco.position=Vector2(-528,0)
	$Barquitos/Barquito2/Barco.position=Vector2(-528,0)
	$Barquitos/Barquito3/Barco.position=Vector2(-528,0)
	$Barquitos/Barquito4/Barco.position=Vector2(3,0)
	$AnimationPlayer.play("FinCaribdis")
	PlayerStats.recuperoVida()
	Global.facedOutSong()
	$Caribdis/Sprites/SpriteDosBocas.frame=0
	$Caribdis/TentaculosAbajo.queue_free()
	$Caribdis.global_position=Vector2(288,0)
	$Caribdis/TimerBurbuja.stop()
	$Caribdis/ZonaMordiscoBarco/TimerZonaMordisco.stop()
	$Caribdis.set_physics_process(false)
	$Jugador.set_physics_process(false)
	$Jugador.Hit.set_deferred("disabled",true) 
	$Jugador/Sprite.flip_h=false
	$Jugador/AnimationPlayer.playback_speed=1
	$Jugador/AnimationPlayer.play("Idle")
	$Jugador.state=0
	$Jugador.set_collision_layer_bit(1,false)
	yield(get_node("AnimationPlayer"),"animation_finished")
	$AnimationPlayer.play("OrbeYFinDeEscena")
	yield(get_node("AnimationPlayer"),"animation_finished")
	$AnimationPlayer.play("CharlaConPoseidon")


func pararBarcos():
	$Barquitos/Barquito/AnimationPlayer2.stop()
	$Barquitos/Barquito2/AnimationPlayer2.stop()
	$Barquitos/Barquito3/AnimationPlayer2.stop()
	$Barquitos/Barquito4/AnimationPlayer2.stop()
	$Barquitos/Barquito5/AnimationPlayer2.stop()

func moverBarcosParaQueVayanSincronizadosEnFinEscena():
	$Barquitos/Barquito/AnimationPlayer2.play()
	$Barquitos/Barquito2/AnimationPlayer2.play()
	$Barquitos/Barquito3/AnimationPlayer2.play()
	$Barquitos/Barquito4/AnimationPlayer2.play()
	$Barquitos/Barquito4/AnimationPlayer2.play()
	$Barquitos/Barquito5/AnimationPlayer2.play()

#Esta función habra que quitarla para version final
func jugadorVuelveATenerColisionParaQueNoCambieAEstadoBrinco():
	$Jugador.set_collision_layer_bit(1,true)
	$Jugador.knockback=Vector2.ZERO
	$Jugador/Hurtbox/CollisionShape2D.set_deferred("disabled",true)
	$Jugador/Hurt_rodar/CollisionShape2D.set_deferred("disabled",true)

func _process(delta):
	if muriendo and get_tree().get_root().get_node("Main_Caribdis").has_node("Caribdis"):
		if $Caribdis.has_node("ProyectilHaciaJugador"):
			$Caribdis/ProyectilHaciaJugador.queue_free()
			muriendo=false

func orbe():
	Global.monstruosVisibleMenu.caribdis=true
	Global.checkpoint=false
	PlayerStats.set_max_health(12)
	PlayerStats.set_health(12)
	var target_stage="res://Escenas/Nivel 3/Nivel2A3.tscn"
	get_tree().change_scene(target_stage)

func _on_Jugador_muriendo():
	$Caribdis/Health_Boss/ProgressBar.visible=false
	$CanvasLayer2.layer=-1
	$ParallaxBackground.layer=-2


func _on_TimerZonaMordisco_timeout():
	if $Caribdis.has_node("ProyectilHaciaJugador"):
			$Caribdis/ProyectilHaciaJugador.queue_free()

func _on_Dialogo_finalice():
	$Jugador.set_physics_process(false)
	$Extrana/CanvasLayer/Dialogo/Timer.stop()
	$Extrana/ZonaDeDialogo/CollisionShape2D.set_deferred("disabled",true)
	$Extrana/CanvasLayer/Dialogo.visible=false
	$AnimationPlayerSecundario.play("AEgiptoAmosDeIr")
	$Jugador.set_physics_process(false)
	$Jugador/AnimationPlayer.play("Idle")

func poseidonTalks(number):
	if number==3:
		$Fin/ColorRect.color=Color("#000000")
		$Extrana/CanvasLayer/Dialogo/Timer.stop()
		$Extrana/ZonaDeDialogo/CollisionShape2D.set_deferred("disabled",true)
		$Extrana/CanvasLayer/Dialogo.visible=false
		$Fin/DialogosCinematicas.iniciar()
		$Fin/TimerCinematicas.start()



func _on_TimerCinematicas_timeout():
	numeroDialogosPoseidon+=1
	if numeroDialogosPoseidon<3:
		$Fin/DialogosCinematicas.iniciar()
		$Fin/TimerCinematicas.start()
	else:
		$Fin/DialogosCinematicas.visible=false
		$AnimationPlayerSecundario.play("OrbeYPegaso")
		yield(get_node("AnimationPlayerSecundario"),"animation_finished")
		$AnimationPlayerSecundario.play("FlotarPegaso")
		$Pegaso/AnimacionPegaso.play("IdlePegaso")
		$Extrana/ZonaDeDialogo/CollisionShape2D.set_deferred("disabled",false)
		$Extrana/CanvasLayer/Dialogo.visible=true
		$Extrana/CanvasLayer/Dialogo/Timer.start()
