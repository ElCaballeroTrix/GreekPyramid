extends Node2D

onready var guardados=get_parent().get_node(".")
var partida
signal cierreMenu()
func _ready():
	$No.grab_focus()

func _process(delta):
	if $Yes.is_hovered():
		$Yes.grab_focus()
	if $No.is_hovered():
		$No.grab_focus()
func _on_Yes_pressed():
	Global.eliminarPartida(partida)
	if partida==Global.Guardado_Texto[0]:
		Global.Guardado[0]=false
		Global.Guardado_Texto[0]="???????????????"
		Global.Fecha.fecha0=null
		Global.TimePlayed.time0=0
		Global.guardar_ajustes()
		guardados.desaparecerPartida(0)
	elif partida==Global.Guardado_Texto[1]:
		Global.Guardado[1]=false
		Global.Guardado_Texto[1]="???????????????"
		Global.Fecha.fecha1=null
		Global.TimePlayed.time1=0
		Global.guardar_ajustes()
		guardados.desaparecerPartida(1)
	elif partida==Global.Guardado_Texto[2]:
		Global.Guardado[2]=false
		Global.Guardado_Texto[2]="???????????????"
		Global.Fecha.fecha2=null
		Global.TimePlayed.time2=0
		Global.guardar_ajustes()
		guardados.desaparecerPartida(2)
	Global.play_sound("res://Sonidos/Menu/Cerrar_Menu.wav")
	queue_free()

func _on_No_pressed():
	Global.play_sound("res://Sonidos/Menu/Cerrar_Menu.wav")
	emit_signal("cierreMenu")
	queue_free()

func _on_Yes_focus_entered():
	$AudioStreamPlayer2D.play()


func _on_Yes_mouse_entered():
	$AudioStreamPlayer2D.play()


func _on_No_focus_entered():
	$AudioStreamPlayer2D.play()


func _on_No_mouse_entered():
	$AudioStreamPlayer2D.play()
