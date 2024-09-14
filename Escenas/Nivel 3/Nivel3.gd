extends Node2D

var enemigosDerrotados=0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.guardar_partida(Global.partidaActiva,false)
	Global.stop_song()
	Global.nombre_audio_suelo="Arena"
	Global.nombre_carpeta_suelo="Arena"
	$Jugador.set_physics_process(false)
	if Global.checkpoint:
		$Jugador.position=$Checkpoint.global_position+Vector2(50,0)
		$AnimationJugador.play("Nivel3CheckPoint")
	else:
		$AnimationJugador.play("Nivel3Inicio")
	$Estatuas/EnemyStatue2/PlayerDetectionZone/CollisionShape2D.set_deferred("disabled",true)
	$Jugador/Camera2D.current=true
#	$ParallaxBackground.offset=Vector2(0,0)

func _on_Dialogo_finalice():
	$Jugador.set_physics_process(true)
	$Jugador/Sprite.flip_h=false
	Global.play_song("res://Sonidos/Musica/Desierto.wav")
func finInicio():
	_on_Dialogo_finalice()

func _on_Area2DArenasMovidizas1_body_entered(body):
	var ruta=String($ArenasMovidizas/ArenasMovidizas1.get_path())+":position:y"
	arenaHaciaAbajo(ruta,$ArenasMovidizas/ArenasMovidizas1,416)

func _on_Area2DArenasMovidizas1_body_exited(body):
	var ruta=String($ArenasMovidizas/ArenasMovidizas1.get_path())+":position:y"
	arenaHaciaArriba(ruta,$ArenasMovidizas/ArenasMovidizas1,$ArenasMovidizas/Position2DArenasMovidizas1)
	
func _on_Area2DArenasMovidizas2_body_entered(body):
	var ruta=String($ArenasMovidizas/ArenasMovidizas2.get_path())+":position:y"
	arenaHaciaAbajo(ruta,$ArenasMovidizas/ArenasMovidizas2,416)

func _on_Area2DArenasMovidizas2_body_exited(body):
	var ruta=String($ArenasMovidizas/ArenasMovidizas2.get_path())+":position:y"
	arenaHaciaArriba(ruta,$ArenasMovidizas/ArenasMovidizas2,$ArenasMovidizas/Position2DArenasMovidizas2)

func _on_Area2DArenasMovidizas3_body_entered(body):
	var ruta=String($ArenasMovidizas/ArenasMovidizas3.get_path())+":position:y"
	arenaHaciaAbajo(ruta,$ArenasMovidizas/ArenasMovidizas3,1520)

func _on_Area2DArenasMovidizas3_body_exited(body):
	var ruta=String($ArenasMovidizas/ArenasMovidizas3.get_path())+":position:y"
	arenaHaciaArriba(ruta,$ArenasMovidizas/ArenasMovidizas3,$ArenasMovidizas/Position2DArenasMovidizas3)

func arenaHaciaArriba(ruta, arena, positionNode):
	var animacionArenas=AnimationPlayer.new()
	add_child(animacionArenas)
	var subirArena=Animation.new()
	animacionArenas.add_animation("SubirArena",subirArena)
	subirArena.add_track(0)
	subirArena.length=2.0
	subirArena.track_set_path(0,ruta)
	subirArena.track_insert_key(0,0.0,arena.global_position.y)
	subirArena.track_insert_key(0,2.0,positionNode.global_position.y)
	animacionArenas.play("SubirArena")

func arenaHaciaAbajo(ruta, arena, posicionFinal):
	var animacionArenas=AnimationPlayer.new()
	add_child(animacionArenas)
	var bajarArena=Animation.new()
	animacionArenas.add_animation("BajarArena",bajarArena)
	bajarArena.add_track(0)
	bajarArena.length=2
	bajarArena.track_set_path(0,ruta)
	bajarArena.track_insert_key(0,0.0,arena.global_position.y)
	bajarArena.track_insert_key(0,2.0,posicionFinal)
	animacionArenas.play("BajarArena")


func moverGusano():
	$Gusanos/Gusano.position.x+=206
	if $Gusanos/Gusano.position.x>=4100:
		$Gusanos/Gusano.queue_free()
		$Gusanos/Gusano2.queue_free()

func moverGusanoGrande():
	$Gusanos/Gusano2.position.x+=213


func _on_PlayerDetectionZone_body_entered(body):
	if body.name=="Jugador":
		#Se habilita que la estatua de la izquierda pueda detectar al jugador para activar la trampa
		$Estatuas/EnemyStatue2/Hurtbox/CollisionShape2D.set_deferred("disabled",false)
		$Estatuas/EnemyStatue2/PlayerDetectionZone/CollisionShape2D.set_deferred("disabled",false)

func _on_Hurtbox_area_entered(area):
	$Estatuas/EnemyStatue2/PlayerDetectionZone/CollisionShape2D.set_deferred("disabled",false)

func _on_Tp_body_entered(body):
	$CameraEnMovimiento.current=true
	#$ParallaxBackground.offset.y=320
	$ParallaxBackground.offset.y=370
	$Jugador.set_physics_process(false)
	$Jugador.state=0
	yield(get_tree().create_timer(0.2),"timeout")
	$AnimacionCamera.play("CameraMoving")
	$AnimationJugador.play("TP_SegundaParte")
	$Gusanos/Gusano/AnimationGusano.play("AnimacionGusanoDesierto")

func jugadorParte2():
	$Jugador.set_physics_process(true)

func comienzaGusanoGrande():
	$Gusanos/Gusano2/AnimationPlayer.play("AnimacionGusanoGrande")

func miniTerremotoGusano():
	$Gusanos/Gusano2/ScreenShake.screen_shake(1,4,2)

############################Enemigos Derrotados############################
func _on_Stats_no_health():
	enemigosDerrotados+=1
#######################
func _on_MuroAlmas_body_entered(body):
	if body.name=="Jugador":
		if enemigosDerrotados>10:
			$AnimacionCamera.play("MuroAlmas")
		else:
			$AnimacionCamera.play("NeedSouls")


func _on_Jugador_teletransporte_muerto():
	get_tree().change_scene("res://Escenas/Nivel 3/Nivel3.tscn")

func _on_PauseMenu_reinicio():
	PlayerStats.health=PlayerStats.max_health
	PlayerStats.recuperoVida()
	$Jugador/Sprite.material.set('shader_param/active',false)
	get_tree().change_scene("res://Escenas/Nivel 3/Nivel3.tscn")

func _on_Jugador_muriendo():
	$Sand.layer=-1
	$ParallaxBackground.layer=-2
	$AnimacionCamera.stop()
