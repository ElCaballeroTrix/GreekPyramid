extends Node2D


func _ready():
	$Tronco.position=Vector2(912,512);
	if OS.has_feature("mobile"):
		$Tronco.weight=100
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.nombre_audio_suelo="Hierba"
	Global.nombre_carpeta_suelo="Hierba"
	$BuclePincho/MovimientoBuclePincho.playback_speed=2
	$Jugador/CanvasLayer/HealthUI.visible=true
	$Jugador/Sprite.flip_h=false
	$Jugador.position=Vector2(16,72)
	$CheckPointransition/ColorRect.color= Color("#00000000")
	if Global.change_scene:
		var cambio=find_node(Global.change_scene)
		if cambio:
			if Global.change_scene=="Parte2":
				$Jugador.global_position=Vector2(0,176)
				$TPs/Tp3/CollisionShape2D.set_deferred("disabled",true)
			if Global.change_scene!="Gorgona":
				if Global.direccion==1 :
					$Jugador.global_position=cambio.global_position +Vector2(20,0)
				else:
					$Jugador.global_position=cambio.global_position - Vector2(20,0)
					$Jugador.sprite.flip_h=true
				if Global.checkpoint:
					$Objeto_Rompible2/Objeto_Rompible/CollisionShape2D.set_deferred("disabled",true)
					$Objeto_Rompible2/CollisionShape2D.set_deferred("disabled",true)
					$Objeto_Rompible2/CollisionShape2D2.set_deferred("disabled",true)
					$Objeto_Rompible2/Sprite.frame=3
					$Objeto_Rompible2/Sprite2.frame=8
			elif Global.checkpoint:
				Global.play_song("res://Sonidos/Musica/Nivel1.wav")
				$Jugador.set_physics_process(false)
				$Jugador.position=Vector2(1000,316.61)
				$AnimationCheckPoint.play("Nivel1Checkpoint")
				yield(get_node("AnimationCheckPoint"),"animation_finished")
				$Jugador.set_physics_process(true) 
				Global.reinicio=false
	elif Global.checkpoint:
		Global.play_song("res://Sonidos/Musica/Nivel1.wav")
		$Jugador.set_physics_process(false)
		$Jugador.position=Vector2(1000,316.61)
		$AnimationCheckPoint.play("Nivel1Checkpoint")
		yield(get_node("AnimationCheckPoint"),"animation_finished")
		$Jugador.set_physics_process(true) 
		Global.reinicio=false


func _on_Jugador_teletransporte_muerto():
	if Global.checkpoint:
		Global.change_scene=null
		get_tree().reload_current_scene()
	else:
		var target_stage="res://Escenas/Nivel 1/Nivel_boss.tscn"
		Global.reinicio=true
		get_tree().change_scene(target_stage)

func permitir_paso_donde_tronco():
	$StaticBody2D4.queue_free()


func _on_PauseMenu_reinicio():
	PlayerStats.health=PlayerStats.max_health
	PlayerStats.recuperoVida()
	$Jugador/Sprite.material.set('shader_param/active',false)
	if Global.checkpoint:
		Global.change_scene=null
		get_tree().reload_current_scene()
	else:
		var target_stage="res://Escenas/Nivel 1/Nivel_boss.tscn"
		Global.reinicio=true
		get_tree().change_scene(target_stage)


func _on_ZonaDeEmpuje_body_entered(body):
	body.empujandoObjeto=true


func _on_ZonaDeEmpuje_body_exited(body):
	body.empujandoObjeto=false
