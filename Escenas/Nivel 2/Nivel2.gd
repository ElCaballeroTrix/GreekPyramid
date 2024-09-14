extends Node2D

var miniBossDead=0
var en_aireMiniBoss=false
var miniBossapareceSegundoEnemigo=false
func _ready():
#	if OS.has_feature("mobile"):
#		$Lighting.visible=false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.guardar_partida(Global.partidaActiva,false)
	Global.nombre_audio_suelo="PiedraMojada"
	Global.nombre_carpeta_suelo="PiedraMojada"
	Global.play_song("res://Sonidos/Musica/MusicaNivel2.wav")
	$Jugador.set_physics_process(false)
	if Global.checkpoint:
		$Jugador.position=Vector2(2112,412.61)
		$AnimationPlayer.play("Nivel2CheckPoint")
	else:
		$AnimationPlayer.play("Nivel2")
	$Peces/EnemigoVaYVuelve.set_physics_process(false)
	$Peces/EnemigoVaYVuelve2.set_physics_process(false)
	$Peces/EnemigoVaYVuelve2.set_physics_process(false)
	$Extrana2.visible=false
	$Extrana2.position.y=700
	$MiniJefe/Limit/CollisionShape2D.set_deferred("disabled",true)
	$MiniJefe/Limit2/CollisionShape2D.set_deferred("disabled",true)
	$MiniJefe/Limit3/CollisionShape2D.set_deferred("disabled",true)
	$MiniJefe/Limit4/CollisionShape2D.set_deferred("disabled",true)
	yield(get_node("AnimationPlayer"),"animation_finished")



func _on_Dialogo_finalice():
	$Jugador.set_physics_process(true)
	$Jugador/Sprite.flip_h=false
	$Peces/EnemigoVaYVuelve.set_physics_process(true)
	$Peces/EnemigoVaYVuelve2.set_physics_process(true)
	$Peces/EnemigoVaYVuelve2.set_physics_process(true)
	$Extrana.mensajeSePuedeVer=true
	comienzo_calamares()

func iniciarTrasCheckpoint():
	_on_Dialogo_finalice()
	$MiniJefe.position.y=-500

func comienzo_calamares():
	yield(get_tree().create_timer(2),"timeout")
	$Calamares/Spawn_Node/Spawn/Timer.start()
	yield(get_tree().create_timer(2),"timeout")
	$Calamares/Spawn_Node3/Spawn/Timer.start()

func _process(delta):
	if en_aireMiniBoss:
		$Jugador.velocidad.x=0
		if $Jugador.on_ground==true:
			en_aireMiniBoss=false
			$Jugador.set_physics_process(false)
			$Jugador/AnimationPlayer.play("Idle")

func _on_Area2D_body_entered(body):
	if body.name=="Jugador":
		$MiniJefe/Area2D/CollisionShape2D.set_deferred("disabled",true)
		if !$Jugador.is_on_floor():
			en_aireMiniBoss=true
			yield(get_tree().create_timer(0.5),"timeout")
		else:
			$Jugador.set_physics_process(false)
			$Jugador/AnimationPlayer.play("Idle")
		$Jugador.state=0
		$MiniJefe/EnemigoAtaca.set_physics_process(false)
		$MiniJefe/EnemigoConDash.set_physics_process(false)
		$MiniJefe/EnemigoConDash/AnimationPlayer.stop()
		$MiniJefe/EnemigoConDash/AnimationPlayer.play("DashEnemigoConDash")
		$MiniJefe/EnemigoConDash/AnimationPlayer.playback_speed=0.5
		$MiniJefe/AnimationPlayer.play("MiniBossNivel2")
		yield(get_node("MiniJefe/AnimationPlayer"),"animation_finished")
		$Jugador.set_physics_process(true)
		$MiniJefe/EnemigoConDash.set_physics_process(true)
		$MiniJefe/EnemigoConDash/Timer.start()
		$MiniJefe/Timer2Enemigo.start()

func idle_mini_boss():
	$MiniJefe/Limit/CollisionShape2D.set_deferred("disabled",false)
	$MiniJefe/Limit2/CollisionShape2D.set_deferred("disabled",false)
	$MiniJefe/Limit3/CollisionShape2D.set_deferred("disabled",false)
	$MiniJefe/Limit4/CollisionShape2D.set_deferred("disabled",false)
	$MiniJefe/EnemigoConDash/AnimationPlayer.play("IdleEnemigoConDash")
	$MiniJefe/EnemigoConDash/AnimationPlayer.playback_speed=1

func _on_EnemigoConDash_dead():
	miniBossDead+=1
	if !miniBossapareceSegundoEnemigo:
		miniBossapareceSegundoEnemigo=true
		saleSegundoEnemigo()
	if miniBossDead==2:
		$MiniJefe/AnimationPlayer.play("MiniBossNivel2BackToNormal")
		$MiniJefe/Limit/CollisionShape2D.set_deferred("disabled",true)
		$MiniJefe/Limit2/CollisionShape2D.set_deferred("disabled",true)
		$MiniJefe/Limit3/CollisionShape2D.set_deferred("disabled",true)
		$MiniJefe/Limit4/CollisionShape2D.set_deferred("disabled",true)

func saleSegundoEnemigo():
	$MiniJefe/Limit/CollisionShape2D.set_deferred("disabled",true)
	$MiniJefe/EnemigoAtaca.set_physics_process(false)
	$MiniJefe/EnemigoAtaca/AnimationPlayer.play("AvanzaEnemigoAtaque")
	$MiniJefe/EnemigoAtaca/AnimationPlayer.playback_speed=0.5
	$MiniJefe/AnimationPlayer.play("ApareceSegundoEnemigo")
	yield(get_node("MiniJefe/AnimationPlayer"),"animation_finished")
	$MiniJefe/Limit/CollisionShape2D.set_deferred("disabled",false)

func idleSegundoEnemigo():
	$MiniJefe/EnemigoAtaca/AnimationPlayer.playback_speed=1
	$MiniJefe/EnemigoAtaca/AnimationPlayer.play("IDLEEnemigoAtaca")
	$MiniJefe/EnemigoAtaca.set_physics_process(true)
	$MiniJefe/EnemigoAtaca/Timer.start()

func _on_Timer2Enemigo_timeout():
	if !miniBossapareceSegundoEnemigo:
		miniBossapareceSegundoEnemigo=true
		saleSegundoEnemigo()


func _on_EnemigoAtaca_dead():
	miniBossDead+=1
	if miniBossDead==2:
		$MiniJefe/AnimationPlayer.play("MiniBossNivel2BackToNormal")
		$MiniJefe/Limit/CollisionShape2D.set_deferred("disabled",true)
		$MiniJefe/Limit2/CollisionShape2D.set_deferred("disabled",true)
		$MiniJefe/Limit3/CollisionShape2D.set_deferred("disabled",true)
		$MiniJefe/Limit4/CollisionShape2D.set_deferred("disabled",true)


func _on_Jugador_teletransporte_muerto():
	get_tree().reload_current_scene()


func _on_PauseMenu_reinicio():
	PlayerStats.health=PlayerStats.max_health
	PlayerStats.recuperoVida()
	$Jugador/Sprite.material.set('shader_param/active',false)
	get_tree().reload_current_scene()

func _on_AreaDialogoConExtraaAntesDeCaribdis_body_entered(body):
	if body.name=="Jugador":
		$Extrana.queue_free()
		$Extrana2.visible=true
		$Jugador.set_physics_process(false)
		$Jugador.velocidad=Vector2.ZERO
		$AnimationPlayer.play("CharlaAntesDeCaribdis")
		$AreaDialogoConExtranaAntesDeCaribdis/CollisionShape2D.set_deferred("disabled",true)


func _on_Jugador_muriendo():
	$CanvasLayer.layer=-1
	$ParallaxBackgroundArriba.layer=-2
	$ParallaxBackgroundNivel2.layer=-2
