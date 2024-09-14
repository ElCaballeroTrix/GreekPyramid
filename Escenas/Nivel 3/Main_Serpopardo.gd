extends Node2D

var jugadorMuriendo=false

# La mejora sería un gancho
func _ready():
	jugadorMuriendo=false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.nombre_audio_suelo="Arena"
	Global.nombre_carpeta_suelo="Arena"
	Global.stop_song()
	$Fondo.scale=Vector2(0.36,0.38)
	$TileMapSegundaFase.set_collision_layer_bit(0,false)
	$TileMapSegundaFase.visible=false
	$TileMap.set_collision_layer_bit(0,true)
	$TileMap.visible=true
	$ArenasMovidizas/ArenaDer/Area2DArenaDer/CollisionShape2D.set_deferred("disabled",true)
	$ArenasMovidizas/ArenaDer/CollisionShape2D.set_deferred("disabled",true)
	$ArenasMovidizas/ArenaIzq/Area2DArenaIzq/CollisionShape2D.set_deferred("disabled",true)
	$ArenasMovidizas/ArenaIzq/CollisionShape2D.set_deferred("disabled",true)
	$SerpoPardo/Sprites/Grito/ColisionGrito/CollisionShape2D.set_deferred("disabled",true)
	$Jugador.set_physics_process(false)
	$SerpoPardo.set_physics_process(false)
	$SerpoPardo/Health_Boss/ProgressBar.visible=false
	$Jugador/CanvasLayer/HealthUI.visible=false

func grito_SerpoPardo():
	$SerpoPardo/AudioSerpoPardo.stream=load("res://Sonidos/Jefes/SerpoPardo/SerpoPardo.wav")
	$SerpoPardo/AudioSerpoPardo.play()
	$SerpoPardo/ScreenShake.screen_shake(3,10,100)

func fin_inicio():
	Global.play_song("res://Sonidos/Musica/SerpopardoFight.wav")
	$SerpoPardo/Health_Boss/ProgressBar.visible=true
	$Jugador/CanvasLayer/HealthUI.visible=true
	$Jugador.set_physics_process(true)
	$SerpoPardo.set_physics_process(true)
	$SerpoPardo.state=2
	$SerpoPardo.currentState()

func _on_SerpoPardo_segundaFase():
	if !jugadorMuriendo:
		Global.stop_song()
		$AnimationPlayer.play("SegundaFase")
		$SerpoPardo.set_physics_process(false)
		$Jugador.set_physics_process(false)
		$Jugador.state=0
		$Jugador.Hit.set_deferred("disabled",true)
		$Jugador/Hurtbox/CollisionShape2D.set_deferred("disabled",true)
		$Jugador/Hurt_rodar/CollisionShape2D.set_deferred("disabled",true)
		$Jugador/AnimationPlayer.play("Idle")
		$Jugador.direccion=1
		$Jugador.knockback=Vector2.ZERO
		$SerpoPardo.state=0
		$SerpoPardo.state_previo=0
		yield(get_tree().create_timer(1),"timeout")
		$Fondo.scale=Vector2(0.36,0.41)
		$Jugador.position=Vector2(31,284.611)
		$Jugador/Sprite.flip_h=false
		$TileMapSegundaFase.set_collision_layer_bit(0,true)
		$TileMapSegundaFase.visible=true
		$TileMap.set_collision_layer_bit(0,false)
		$TileMap.set_collision_mask_bit(0,false)
		$TileMap.visible=false
		$ArenasMovidizas/ArenaDer/Area2DArenaDer/CollisionShape2D.set_deferred("disabled",false)
		$ArenasMovidizas/ArenaDer/CollisionShape2D.set_deferred("disabled",false)
		$ArenasMovidizas/ArenaIzq/Area2DArenaIzq/CollisionShape2D.set_deferred("disabled",false)
		$ArenasMovidizas/ArenaIzq/CollisionShape2D.set_deferred("disabled",false)

func finCambioFase():
	Global.play_song("res://Sonidos/Musica/SerpopardoFightSpedUp.wav")
	$SerpoPardo.enCambioFase=false
	$SerpoPardo.set_physics_process(true)
	$Jugador.set_physics_process(true)
	$Jugador/Hurtbox/CollisionShape2D.set_deferred("disabled",false)
	$Jugador/Hurt_rodar/CollisionShape2D.set_deferred("disabled",false)
	$SerpoPardo.changeState()


func _on_PauseMenu_reinicio():
	PlayerStats.health=PlayerStats.max_health
	$Jugador/Sprite.material.set('shader_param/active',false)
	var target_stage="res://Escenas/Nivel 3/Nivel3.tscn"
	get_tree().change_scene(target_stage)


######################################
##########Arenas Movidizas############
######################################
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

func _on_Area2DArenaIzq_body_entered(body):
	if body.name=="Jugador":
		var ruta=String($ArenasMovidizas/ArenaIzq.get_path())+":position:y"
		arenaHaciaAbajo(ruta,$ArenasMovidizas/ArenaIzq,416)

func _on_Area2DArenaIzq_body_exited(body):
	if body.name=="Jugador":
		var ruta=String($ArenasMovidizas/ArenaIzq.get_path())+":position:y"
		arenaHaciaArriba(ruta,$ArenasMovidizas/ArenaIzq,$ArenasMovidizas/PositionArenaIzq)

func _on_Area2DArenaDer_body_entered(body):
	if body.name=="Jugador":
		var ruta=String($ArenasMovidizas/ArenaDer.get_path())+":position:y"
		arenaHaciaAbajo(ruta,$ArenasMovidizas/ArenaDer,416)

func _on_Area2DArenaDer_body_exited(body):
	if body.name=="Jugador":
		var ruta=String($ArenasMovidizas/ArenaDer.get_path())+":position:y"
		arenaHaciaArriba(ruta,$ArenasMovidizas/ArenaDer,$ArenasMovidizas/PositionArenaDer)


func _on_SerpoPardo_dead():
	Global.facedOutSong(-80,4)
	$SerpoPardo/Sprites/SpriteSerpopardo.flip_h=false
	$SerpoPardo/AnimacionSerpoPardo.stop()
	$SerpoPardo/Sprites/SpriteSerpopardo.frame=0
	$AnimationPlayer.play("FinalSerpoPardo")
	$SerpoPardo.set_physics_process(false)
	$SerpoPardo/TimerLanza.stop()
	$SerpoPardo/Rocas/TimerRocas.stop()
	$SerpoPardo.state=0
	$Jugador.set_physics_process(false)
	$Jugador.state=0
	$Jugador.Hit.set_deferred("disabled",true)
	$Jugador/Hurtbox/CollisionShape2D.set_deferred("disabled",true)
	$Jugador/Hurt_rodar/CollisionShape2D.set_deferred("disabled",true)
	$Jugador.direccion=1
	$Jugador.knockback=Vector2.ZERO


func _on_Dialogo_finalice():
	$FinalAlfa.visible=true


func _on_Jugador_muriendo():
	jugadorMuriendo=true
	$SerpoPardo/Health_Boss/ProgressBar.visible=false
	$CanvasLayer2.layer=-1

func _on_Jugador_teletransporte_muerto():
	var target_stage="res://Escenas/Nivel 3/Nivel3.tscn"
	get_tree().change_scene(target_stage)
