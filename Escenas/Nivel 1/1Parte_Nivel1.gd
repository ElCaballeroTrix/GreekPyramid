extends Node2D

var empieza=true
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.nombre_audio_suelo="Hierba"
	Global.nombre_carpeta_suelo="Hierba"
	#if empieza:
		#empieza=false
		#$Jugador.set_physics_process(false)
		#$AnimationPlayer.play("Entrada")
		#yield(get_node("AnimationPlayer"),"animation_finished")
		#$Jugador.set_physics_process(true)
	if Global.change_scene and !Global.reinicio and Global.change_scene!="Gorgona":
		var cambio=find_node(Global.change_scene)
		if cambio:
			if Global.change_scene=="Parte2":
				$Jugador.global_position=Vector2(1024,272)
			if Global.direccion==1:
				$Jugador.global_position=cambio.global_position +Vector2(20,0)
			else:
				$Jugador.global_position=cambio.global_position -Vector2(20,0)
				$Jugador.sprite.flip_h=true
		Global.change_scene=null
	else:
		Global.play_song("res://Sonidos/Musica/Nivel1.wav")
		$Jugador.set_physics_process(false)
		$AnimationPlayer.play("Entrada")
		yield(get_node("AnimationPlayer"),"animation_finished")
		$Jugador.set_physics_process(true) 
		Global.reinicio=false

func _on_Jugador_teletransporte_muerto():
	if Global.checkpoint:
		get_tree().change_scene("res://Escenas/Nivel 1/2Parte_Nivel_1.tscn")
	else:
		get_tree().change_scene("res://Escenas/Nivel 1/Nivel_boss.tscn")

func _on_PauseMenu_reinicio():
	PlayerStats.health=PlayerStats.max_health
	PlayerStats.recuperoVida()
	$Jugador/Sprite.material.set('shader_param/active',false)
	if Global.checkpoint:
		get_tree().change_scene("res://Escenas/Nivel 1/2Parte_Nivel_1.tscn")
	else:
		get_tree().change_scene("res://Escenas/Nivel 1/Nivel_boss.tscn")
