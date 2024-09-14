extends Node2D

var recibiendoDano_Stun=false
var en_aireBoss=false
var fin_stun=false
func _ready():
	if OS.has_feature("mobile"):
		$Antorchas/Antorcha/Sprite/Light2D.visible=false
		$Antorchas/Antorcha2/Sprite/Light2D.visible=false
		$Antorchas/Antorcha3/Sprite/Light2D.visible=false
		$Antorchas/Antorcha4/Sprite/Light2D.visible=false
		$Antorchas/Antorcha5/Sprite/Light2D.visible=false
		$Jugador/Stun_Gorgona/Light2D.visible=false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.nombre_audio_suelo="Piedra"
	Global.nombre_carpeta_suelo="Piedra"
	Global.reinicio=false
	Global.stop_song()
	$Jugador.set_physics_process(false)
	$Gorgona.set_physics_process(false)
	$AnimationPlayer.play("Entrada")
	yield(get_node("AnimationPlayer"),"animation_finished")
	if OS.has_feature("mobile"):
		$Camera2D.zoom=Vector2(1.58,1.411)
		$Camera2D.position=Vector2(265,510)
	$Gorgona/AudioStreamPlayer.stream=load("res://Sonidos/Gorgona/Gritos_Gorgona.wav")
	$Gorgona/Sprite_Gorgona.frame=1
	$Gorgona/AudioStreamPlayer.play()
	$ScreenShake.screen_shake(3,10,100)
	yield(get_tree().create_timer(2),"timeout")
	Global.play_song("res://Sonidos/Musica/Tenebroso.wav")
	$Gorgona/AudioStreamPlayer.volume_db=-10
	$Gorgona/Health_Boss/ProgressBar.visible=true
	$Jugador/CanvasLayer/HealthUI.visible=true
	$Jugador.set_physics_process(true)
	$Gorgona.set_physics_process(true)
	#Inicio Estalagtitas
	$Estalagtitas/TimerIzq.start()
	$Estalagtitas/Spawn/Spawn/Timer.start()
	$Estalagtitas/Spawn2/Spawn/Timer.start()
	$Estalagtitas/Spawn3/Spawn/Timer.start()
	$Estalagtitas/Spawn4/Spawn/Timer.start()
	$Estalagtitas/Spawn5/Spawn/Timer.start()
	$Estalagtitas/Spawn6/Spawn/Timer.start()


func _process(delta):
	if en_aireBoss:
		$Jugador.velocidad.x=0
		$Jugador/AnimationPlayer.stop(false)
		if $Jugador.on_ground==true and !fin_stun:
			$Jugador.set_physics_process(false)
			#$Jugador/AnimationPlayer.stop(false)
			#en_aireBoss=false
		elif fin_stun:
			en_aireBoss=false
			fin_stun=false

func _on_Gorgona_dead():
	$Jugador.attack_animation_finished()
	#Velocidad.x a 1, para que no realice knockback.x(mira Jugador.gd linea 496)
	$Jugador.velocidad.x=1
	$Jugador.velocidad.y=0
	$Jugador/Sprite.material.shader=load("res://Shaders/Blink.shader")
	$Jugador.state=0
	#Es una movida, y todo tiene que ver con scale.x, move_and_slide
	#que el Jugador este encima, asique este es el apaño
	#P.D: no cambiar el scale.x de negativo a positivo de los KinematicBody*
	if $Gorgona.scale.x==-1:
		if $Gorgona.Jugador_Encima:
			$Gorgona.scale.x=-1
		else: 
			if $Gorgona.scale2==1:
				$Gorgona.scale.x=-1
			else:$Gorgona.scale.x=1
	######
	$Gorgona.Jugador_Encima=false
	$Jugador/Hurtbox/CollisionShape2D.set_deferred("disabled",true)
	$Jugador/Hurt_rodar/CollisionShape2D.set_deferred("disabled",true)
	$Jugador/CanvasLayer/HealthUI.visible=false
	$Gorgona/Timer_Movimiento.stop()
	$Gorgona/Animacion_Coletazo.stop()
	$Gorgona/AnimationPlayer.stop()
	$AnimationPlayer.play("FinGorgona")
	PlayerStats.recuperoVida()
	Global.facedOutSong()
	$Gorgona/Sprite_Gorgona.frame=10
	$Gorgona/Spawn_Node.queue_free()
	if $Gorgona/Dano_Stun/Stun_Animacion.is_playing():
		$Gorgona/Dano_Stun/Stun_Animacion.stop()
		$Gorgona/Dano_Stun/Stun_Animacion.seek(0.0,true)
		#yield(get_node("Gorgona/Dano_Stun/Stun_Animacion"),"animation_finished")
	$Gorgona.global_position=Vector2(462,536)
	$Estalagtitas.queue_free()
	$Gorgona.set_physics_process(false)
	$Jugador.set_physics_process(false)
	$Jugador.global_position=Vector2(100,540)
	$Jugador.Hit.set_deferred("disabled",true) 
	$Jugador/Sprite.flip_h=false
	$Jugador/AnimationPlayer.play("Idle") 
	$Jugador.on_ground=true
	PlayerStats.set_max_health(10)
	PlayerStats.set_health(10)
	yield(get_node("AnimationPlayer"),"animation_finished")
	$Gorgona/AudioStreamPlayer.stream=load("res://Sonidos/Gorgona/Gritos_Gorgona.wav")
	$Gorgona/AudioStreamPlayer.play()
	yield(get_tree().create_timer(2),"timeout")
	$Gorgona.queue_free()
	#Faltaria a lo mejor, explosion o algo así
	Global.monstruosVisibleMenu.gorgona=true
	$AnimationPlayer.play("SalvasAExtrana")
	#$AnimationPlayer.play("Salida")


func _on_Limite_Correr_body_entered(body):
	if body.name=="Gorgona":
		if $Limite_Correr.global_position==Vector2(50,536):
			$Limite_Correr.global_position=Vector2(476,536)
		else: $Limite_Correr.global_position=Vector2(50,536)
		$Limite_Correr/CollisionShape2D.set_deferred("disabled",true)
		$Gorgona.fin_movimiento()

func _on_Timer_Movimiento_timeout():
	yield(get_tree().create_timer(0.5),"timeout") #Estaba antes en 2 segundos
	$Limite_Correr/CollisionShape2D.disabled=false

func _on_Jugador_teletransporte_muerto():
	var target_stage
	if Global.checkpoint:
		target_stage="res://Escenas/Nivel 1/2Parte_Nivel_1.tscn"
	else:
		target_stage="res://Escenas/Nivel 1/Nivel_boss.tscn"
	get_tree().change_scene(target_stage)

func _on_Dano_Stun_area_entered(area):
	if !recibiendoDano_Stun:
		$Gorgona.dentroZonaStun=true
		recibiendoDano_Stun=true
		$Gorgona/Cuerpo/CollisionShape2D.set_deferred("disabled",true)
		if !$Jugador.is_on_floor():
			en_aireBoss=true
		else: $Jugador.set_physics_process(false)
		if $Jugador.Hit!=null:
			$Jugador.Hit.set_deferred("disabled",true)
		$Jugador/AnimationPlayer.stop()
		$Jugador/Sprite.material.shader=load("res://Shaders/Piedra.shader")
		$Jugador/Hurtbox.set_collision_layer_bit(2,false)
		$Jugador/Hurt_rodar.set_collision_layer_bit(2,false)


func _on_Gorgona_fin_stun():
	fin_stun=true
	recibiendoDano_Stun=false
	$Jugador/Hurtbox.set_collision_layer_bit(2,true)
	$Jugador/Hurt_rodar.set_collision_layer_bit(2,true)
	$Jugador/Sprite.material.shader=load("res://Shaders/Blink.shader")
	$Gorgona/Cuerpo/CollisionShape2D.disabled=false
	$Jugador.set_physics_process(true)

func _on_PauseMenu_reinicio():
	PlayerStats.health=PlayerStats.max_health
	$Jugador/Sprite.material.set('shader_param/active',false)
	var target_stage
	if Global.checkpoint:
		target_stage="res://Escenas/Nivel 1/2Parte_Nivel_1.tscn"
	else:
		target_stage="res://Escenas/Nivel 1/Nivel_boss.tscn"
	get_tree().change_scene(target_stage)

func _on_TimerDer_timeout():
	$Estalagtitas/TimerDer.stop()
	$Estalagtitas/TimerIzq.start()
	$Estalagtitas/Spawn/Spawn/Timer.start()
	$Estalagtitas/Spawn2/Spawn/Timer.start()
	$Estalagtitas/Spawn3/Spawn/Timer.start()
	$Estalagtitas/Spawn4/Spawn/Timer.start()
	$Estalagtitas/Spawn5/Spawn/Timer.start()
	$Estalagtitas/Spawn6/Spawn/Timer.start()
	$Estalagtitas/Spawn7/Spawn/Timer.stop()
	$Estalagtitas/Spawn8/Spawn/Timer.stop()
	$Estalagtitas/Spawn9/Spawn/Timer.stop()
	$Estalagtitas/Spawn10/Spawn/Timer.stop()
	$Estalagtitas/Spawn11/Spawn/Timer.stop()
	$Estalagtitas/Spawn12/Spawn/Timer.stop()


func _on_TimerIzq_timeout():
	$Estalagtitas/TimerIzq.stop()
	$Estalagtitas/TimerDer.start()
	$Estalagtitas/Spawn/Spawn/Timer.stop()
	$Estalagtitas/Spawn2/Spawn/Timer.stop()
	$Estalagtitas/Spawn3/Spawn/Timer.stop()
	$Estalagtitas/Spawn4/Spawn/Timer.stop()
	$Estalagtitas/Spawn5/Spawn/Timer.stop()
	$Estalagtitas/Spawn6/Spawn/Timer.stop()
	$Estalagtitas/Spawn7/Spawn/Timer.start()
	$Estalagtitas/Spawn8/Spawn/Timer.start()
	$Estalagtitas/Spawn9/Spawn/Timer.start()
	$Estalagtitas/Spawn10/Spawn/Timer.start()
	$Estalagtitas/Spawn11/Spawn/Timer.start()
	$Estalagtitas/Spawn12/Spawn/Timer.start()


func _on_Dialogo_finalice():
	$Jugador.set_physics_process(false)

func _on_Jugador_muriendo():
	$Gorgona/Health_Boss/ProgressBar.visible=false
