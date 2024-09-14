extends Node

var puede_hacer_ruido=false
var empezar_ciclo=false
var saltarIntro=false
func _ready():
	Global.checkpoint=false
	Global.change_scene=null
	PlayerStats.recuperoVida()
	Global.Escena="res://Escenas/Nivel 1/Tutorial.tscn"
	Global.datos_partida.escena="res://Escenas/Nivel 1/Tutorial.tscn"
	$ParallaxBackground/Botones/Menu_Principal/Jugar.grab_focus()
	Global.play_song("res://Sonidos/Musica/FlautaAction.wav")
	yield(get_tree().create_timer(13.71),"timeout")
	Global.play_song("res://Sonidos/Musica/Epicidad.wav")

func _physics_process(delta):
	if empezar_ciclo==true:
		$AnimationPlayer.play("BucleFondo")
		empezar_ciclo=false
	$ParallaxBackground/Arena.motion_offset.x-=3
	$ParallaxBackground/Arena_Fondo1.motion_offset.x+=1
	$ParallaxBackground/Arena_Fondo2.motion_offset.x+=0.8
	$ParallaxBackground/Arena_Fondo3.motion_offset.x+=0.6
	$ParallaxBackground/Hierba.motion_offset.x-=3
	$ParallaxBackground/Hierba_Fondo1.motion_offset.x+=1
	$ParallaxBackground/Hierba_Fondo2.motion_offset.x+=0.8
	$ParallaxBackground/Hierba_Fondo3.motion_offset.x+=0.6
	$Animacion_Jugador.play("Jugador_Correr")

func iniciar_ciclo():
	empezar_ciclo=true

func _on_Opciones_pressed():
	$AudioStreamPlayer.stream=load("res://Sonidos/Menu/Abrir_Menu.wav")
	$AudioStreamPlayer.play()

func _on_Jugar_focus_entered():
	if puede_hacer_ruido:
		$SonidoEncima.play()

func _on_Jugar_mouse_entered():
	if puede_hacer_ruido:
		$SonidoEncima.play()

func _on_Opciones_focus_entered():
	if puede_hacer_ruido:
		$SonidoEncima.play()

func _on_Opciones_mouse_entered():
	if puede_hacer_ruido:
		$SonidoEncima.play()

func _on_Salir_focus_entered():
	if puede_hacer_ruido:
		$SonidoEncima.play()

func _on_Salir_mouse_entered():
	if puede_hacer_ruido:
		$SonidoEncima.play()

func permitir_texto():
	puede_hacer_ruido=true
	saltarIntro=true

func _input(event):
	if !saltarIntro and (event.is_action_pressed("ui_accept") or (event is InputEventScreenTouch and event.is_pressed())):
		saltarIntro=true
		$AnimationPlayer.playback_speed=100
		yield(get_node("AnimationPlayer"),"animation_finished")
		Global.play_song("res://Sonidos/Musica/Epicidad.wav")
		$AnimationPlayer.playback_speed=1
