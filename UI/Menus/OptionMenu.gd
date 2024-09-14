extends Node2D

onready var resolucion=$MarginContainer/HBoxContainer/Columna2/OptionButton
onready var FullScreen=$MarginContainer/HBoxContainer/Columna2/Label2/Boton_Pantalla
onready var Sonido=$MarginContainer/HBoxContainer/Columna1/VBoxContainer/HSlider
onready var Musica=$MarginContainer/HBoxContainer/Columna1/VBoxContainer/HSlider2
onready var Controls=$MarginContainer/HBoxContainer/Columna2/Controlls
onready var Exit=$MarginContainer/HBoxContainer/Columna3/Exit
signal cierreMenu()
func _ready():
	Sonido.value=Global.Nivel_Sonido
	Musica.value=Global.Nivel_Musica
	if OS.has_feature("mobile"):
		$MarginContainer/HBoxContainer/Columna2.visible=false
	Exit.grab_focus()
	add_items()
	apariencia_FullScreen()

func _input(event):
	if event.is_action_pressed("ui_cancel") || event.is_action_pressed("menu"):
		cerrarMenu()

func _process(delta):
	if Global.Sali_Menu==true:
		$AudioStreamPlayer.stream=load("res://Sonidos/Menu/Cerrar_Menu.wav")
		$AudioStreamPlayer.play()
		Global.Sali_Menu=false
	if Exit.is_hovered()==true:
		Exit.grab_focus()
	if Controls.is_hovered()==true:
		Controls.grab_focus()
func add_items():
	resolucion.add_item("(640,480)")
	resolucion.add_item("(720,480)")
	resolucion.add_item("(720,576)")
	resolucion.add_item("(800,600)")
	resolucion.add_item("(1024,600)")
	resolucion.add_item("(1152,864)")
	resolucion.add_item("(1280,720)")
	resolucion.add_item("(1280,800)")
	resolucion.add_item("(1280,960)")
	resolucion.add_item("(1280,1024)")
	resolucion.add_item("(1360,768)")
	resolucion.add_item("(1440,900)")
	resolucion.add_item("(1600,900)")
	resolucion.add_item("(1600,1200)")
	resolucion.add_item("(1680,1050)")
	resolucion.add_item("(1920,1080)")
	resolucion._select_int(Global.Resolucion)

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sonido"),value)
	Global.Nivel_Sonido=value


func _on_HSlider2_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"),value)
	Global.Nivel_Musica=value


func _on_OptionButton_item_selected(index):
	if index==0: OS.set_window_size(Vector2(640,480))
	if index==1: OS.set_window_size(Vector2(720,480))
	if index==2: OS.set_window_size(Vector2(720,576))
	if index==3: OS.set_window_size(Vector2(800,600))
	if index==4: OS.set_window_size(Vector2(1024,600))
	if index==5: OS.set_window_size(Vector2(1152,864))
	if index==6: OS.set_window_size(Vector2(1280,720))
	if index==7: OS.set_window_size(Vector2(1280,800))
	if index==8: OS.set_window_size(Vector2(1280,960))
	if index==9: OS.set_window_size(Vector2(1280,1024))
	if index==10: OS.set_window_size(Vector2(1360,768))
	if index==11: OS.set_window_size(Vector2(1440,900))
	if index==12: OS.set_window_size(Vector2(1600,900))
	if index==13: OS.set_window_size(Vector2(1600,1200))
	if index==14: OS.set_window_size(Vector2(1680,1050))
	if index==15: OS.set_window_size(Vector2(1920,1080))
	Global.Resolucion=index
	$AudioStreamPlayer.play()


func _on_TextureButton_pressed():
	Global.FullScreen=not Global.FullScreen
	$AudioStreamPlayer.play()
	OS.window_fullscreen = !OS.window_fullscreen
	apariencia_FullScreen()

func cerrarMenu():
	Global.Sali_Menu=true
	Global.guardar_ajustes()
	emit_signal("cierreMenu")
	queue_free()

func _on_Exit_pressed():
	cerrarMenu()

func apariencia_FullScreen():
	if Global.FullScreen==true:
		FullScreen.texture_normal=load("res://UI/Menus/Boton_Aceptado.png")
	else: FullScreen.texture_normal=load("res://UI/Menus/Boton.png")


func _on_Controlls_pressed():
	$AudioStreamPlayer.stream=load("res://Sonidos/Menu/Abrir_Menu.wav")
	$AudioStreamPlayer.play()
	var Escena_Opcion=load("res://UI/Menus/Controls.tscn")
	var Escena=Escena_Opcion.instance()
	Escena.connect("cierreMenu",self,"apuntaABotonOpciones")
	add_child(Escena)

func apuntaABotonOpciones():
	Exit.grab_focus()

func _on_Controlls_focus_entered():
	$AudioStreamPlayer.play()

func _on_Controlls_mouse_entered():
	$AudioStreamPlayer.play()

func _on_Exit_focus_entered():
	$AudioStreamPlayer.play()

func _on_Exit_mouse_entered():
	$AudioStreamPlayer.play()

func _on_Boton_Pantalla_focus_entered():
	$AudioStreamPlayer.play()
	
func _on_Boton_Pantalla_mouse_entered():
	$AudioStreamPlayer.play()
