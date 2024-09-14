extends Node2D

onready var Opcion1=$MarginContainer/VBoxContainer/TextureButton1
onready var Opcion2=$MarginContainer/VBoxContainer/TextureButton2
onready var Opcion3=$MarginContainer/VBoxContainer/TextureButton3
onready var Opcion4=$MarginContainer/VBoxContainer/TextureButton4
onready var gorgonaImagen=$Monstruos/HBoxContainer/Griegos/Gorgona
onready var caribdisImagen=$Monstruos/HBoxContainer/Griegos/Caribdis
onready var serpopardoImagen=$Monstruos/HBoxContainer/Egipcios/Serpopardo
onready var egipcios=$Monstruos/HBoxContainer/Egipcios
onready var imagenesMonstruos=[gorgonaImagen,caribdisImagen, serpopardoImagen]
var numero=1
signal reinicio()
signal opciones()
signal titulo()
func _ready():
#	Opcion1.grab_focus()
	if Global.monstruosVisibleMenu.gorgona:
		gorgonaImagen.visible=true
		if Global.habilidadActivaMonstruo.gorgona:
			gorgonaImagen.pressed=true
	if Global.monstruosVisibleMenu.caribdis:
		caribdisImagen.visible=true
		$Orbes/OrbePoseidon.visible=true
		if Global.habilidadActivaMonstruo.caribdis:
			caribdisImagen.pressed=true
	if Global.monstruosVisibleMenu.serpopardo:
		serpopardoImagen.visible=true
		gorgonaImagen.focus_neighbour_right = serpopardoImagen.get_path()
		$MarginContainer/VBoxContainer/TextureButton1.focus_neighbour_left = serpopardoImagen.get_path()
		if Global.habilidadActivaMonstruo.serpopardo:
			serpopardoImagen.pressed=true

func _physics_process(delta):
	if Global.Sali_Menu==true:
		$AudioStreamPlayer.stream=load("res://Sonidos/Menu/Cerrar_Menu.wav")
		$AudioStreamPlayer.play()
		Global.Sali_Menu=false
	if Opcion1.is_hovered()==true:
		Opcion1.grab_focus()
	if Opcion2.is_hovered()==true:
		Opcion2.grab_focus()
	if Opcion3.is_hovered()==true:
		Opcion3.grab_focus()
	if Opcion4.is_hovered()==true:
		Opcion4.grab_focus()
	#******Esto se quitara, es solo para la demo, para que puedan probar el colmillo*****
#	if Global.monstruosVisibleMenu.caribdis:
#		caribdisImagen.visible=true
#		$Orbes/OrbePoseidon.visible=true
#		if Global.habilidadActivaMonstruo.caribdis:
#			caribdisImagen.pressed=true

func _input(event):
	if (event.is_action_pressed("ui_cancel") || event.is_action_pressed("menu")) && visible==true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$AudioStreamPlayer.stream=load("res://Sonidos/Menu/Cerrar_Menu.wav")
		$AudioStreamPlayer.play()
		Opcion1.grab_focus()
		get_tree().paused=not get_tree().paused
		visible=not visible
	elif event.is_action_pressed("ui_cancel") || event.is_action_pressed("menu"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$AudioStreamPlayer.stream=load("res://Sonidos/Menu/Abrir_Menu.wav")
		$AudioStreamPlayer.play()
		Opcion1.grab_focus()
		get_tree().paused=not get_tree().paused
		visible=not visible

#######################Menu###############################
func _on_TextureButton1_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused=not get_tree().paused
	visible=not visible
	$AudioStreamPlayer.stream=load("res://Sonidos/Menu/Cerrar_Menu.wav")
	$AudioStreamPlayer.play()


func _on_TextureButton4_pressed():
	Global.play_sound("res://Sonidos/Menu/Cerrar_Menu.wav")
	get_tree().paused=not get_tree().paused
	Global.guardar_partida(Global.partidaActiva,false)
	get_tree().change_scene("res://UI/Menus/TitleScreen.tscn")


func _on_TextureButton2_pressed():
	Global.play_sound("res://Sonidos/Menu/Cerrar_Menu.wav")
	emit_signal("reinicio")
	get_tree().paused=not get_tree().paused
	visible=not visible


func _on_TextureButton3_pressed():
	$AudioStreamPlayer.stream=load("res://Sonidos/Menu/Abrir_Menu.wav")
	$AudioStreamPlayer.play()
	var Escena_Opcion=load("res://UI/Menus/OptionMenu.tscn")
	var Escena=Escena_Opcion.instance()
	Escena.connect("cierreMenu",self,"apuntaABotonOpciones")
	add_child(Escena)

func apuntaABotonOpciones():
	Opcion1.grab_focus()

func _on_TextureButton1_focus_entered():
	$SonidoEncima.play()


func _on_TextureButton1_mouse_entered():
	$SonidoEncima.play()


func _on_TextureButton2_focus_entered():
	$SonidoEncima.play()


func _on_TextureButton2_mouse_entered():
	$SonidoEncima.play()


func _on_TextureButton3_focus_entered():
	$SonidoEncima.play()

func _on_TextureButton3_mouse_entered():
	$SonidoEncima.play()

func _on_TextureButton4_focus_entered():
	$SonidoEncima.play()

func _on_TextureButton4_mouse_entered():
	$SonidoEncima.play()

#################Habilidades##############################
#####Gorgona#######
func _on_Gorgona_pressed():
	if !Global.habilidadActivaMonstruo.gorgona:
		desactivar("gorgona",gorgonaImagen)
		gorgonaImagen.pressed=true
		Global.cambiarHabilidad("gorgona")

func desactivar(activa,imagenActiva):
	for iteracion in Global.habilidadActivaMonstruo:
		if iteracion!=activa:
			Global.habilidadActivaMonstruo[iteracion]=false
	for boton in imagenesMonstruos:
		if boton!=imagenActiva:
			boton.pressed=false

func _on_Gorgona_focus_entered():
	$SonidoEncima.play()


func _on_Gorgona_mouse_entered():
	$SonidoEncima.play()


func _on_Caribdis_pressed():
	if !Global.habilidadActivaMonstruo.caribdis:
		desactivar("caribdis",caribdisImagen)
		caribdisImagen.pressed=true
		Global.cambiarHabilidad("caribdis")


func _on_Caribdis_focus_entered():
	$SonidoEncima.play()


func _on_Caribdis_mouse_entered():
	$SonidoEncima.play()


func _on_Serpopardo_pressed():
	if !Global.habilidadActivaMonstruo.serpopardo:
		desactivar("serpopardo",serpopardoImagen)
		serpopardoImagen.pressed=true
		Global.cambiarHabilidad("serpopardo")


func _on_Serpopardo_focus_entered():
	$SonidoEncima.play()


func _on_Serpopardo_mouse_entered():
	$SonidoEncima.play()
