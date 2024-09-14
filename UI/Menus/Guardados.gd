extends Node2D


onready var Game0=$MarginContainer/VBoxContainer/Partida1/VBoxContainer/Nombrepartida1
onready var Game1=$MarginContainer/VBoxContainer/Partida2/VBoxContainer/Nombrepartida2
onready var Game2=$MarginContainer/VBoxContainer/Partida3/VBoxContainer/Nombrepartida3
onready var Fecha0=$MarginContainer/VBoxContainer/Partida1/VBoxContainer/HBoxContainer/Date
onready var Fecha1=$MarginContainer/VBoxContainer/Partida2/VBoxContainer/HBoxContainer/Date
onready var Fecha2=$MarginContainer/VBoxContainer/Partida3/VBoxContainer/HBoxContainer/Date
onready var Timer0=$MarginContainer/VBoxContainer/Partida1/VBoxContainer/HBoxContainer/Time
onready var Timer1=$MarginContainer/VBoxContainer/Partida2/VBoxContainer/HBoxContainer/Time
onready var Timer2=$MarginContainer/VBoxContainer/Partida3/VBoxContainer/HBoxContainer/Time
signal nombre_escrito
signal cierreMenu()
# Called when the node enters the scene tree for the first time.
func _ready():
	#Si hay algo por encima de un botón, este no puede detectar el ratón
	#Por ello, se hace invisible al inicio
	$ColorRect2.visible=false
	Game0.max_length=20
	Game1.max_length=20
	Game2.max_length=20
	estado_partidas()
	if Game0.editable==true && !OS.has_feature("mobile"):
		Game0.grab_focus()
	else:$Button0.grab_focus()

func _process(delta):
	if $Button0.is_hovered():
		$Button0.modulate=Color(0,0.09,1,0.56)
	else:$Button0.modulate=Color(1,1,1,0.56)
	if $Button1.is_hovered():
		$Button1.modulate=Color(0,0.09,1,0.56)
	else:$Button1.modulate=Color(1,1,1,0.56)
	if $Button2.is_hovered():
		$Button2.modulate=Color(0,0.09,1,0.56)
	else:$Button2.modulate=Color(1,1,1,0.56)

func _input(event):
	if event.is_action_pressed("ui_cancel") || event.is_action_pressed("menu"):
		emit_signal("cierreMenu")
		queue_free()

func estado_partidas():
	for i in range(3):
		if Global.Guardado[i]==true:
			if i==0:
				Game0.editable=false
				Game0.text=Global.Guardado_Texto[i]
				$Button0.set_deferred("disabled",false)
				$Button0.visible=true
				Fecha0.text=" "+String(Global.Fecha.fecha0.day)+"-"+String(Global.Fecha.fecha0.month)+"-"+String(Global.Fecha.fecha0.year) +" ("+ String(Global.Fecha.fecha0.hour)+":"+String(Global.Fecha.fecha0.minute)+")"
				$Borrado0.visible=true
				$Borrado0.set_deferred("disabled",false)
				var time=timeToHoursMin(int(Global.TimePlayed.time0))
				Timer0.text="Time Played: %02d:%02d" % [time[0],time[1]]
				if Global.Guardado[1]==true:
					$Button0.focus_neighbour_bottom=NodePath("../Button1")
				else: $Button0.focus_neighbour_bottom=NodePath("../MarginContainer/VBoxContainer/Partida2/VBoxContainer/Nombrepartida2")
				if Global.Guardado[2]==true:
					$Button0.focus_neighbour_top=NodePath("../Button2")
				else: $Button0.focus_neighbour_top=NodePath("../MarginContainer/VBoxContainer/Partida3/VBoxContainer/Nombrepartida3")
			elif i==1:
				Game1.editable=false
				Game1.text=Global.Guardado_Texto[i]
				$Button1.set_deferred("disabled",false)
				$Button1.visible=true
				Fecha1.text=" "+String(Global.Fecha.fecha1.day)+"-"+String(Global.Fecha.fecha1.month)+"-"+String(Global.Fecha.fecha1.year) +" ("+ String(Global.Fecha.fecha1.hour)+":"+String(Global.Fecha.fecha1.minute)+")"
				$Borrado1.visible=true
				$Borrado1.set_deferred("disabled",false)
				var time=timeToHoursMin(int(Global.TimePlayed.time1))
				Timer1.text="Time Played: %02d:%02d" % [time[0],time[1]]
				if Global.Guardado[0]==true:
					$Button1.focus_neighbour_top=NodePath("../Button0")
				else:$Button1.focus_neighbour_top=NodePath("../MarginContainer/VBoxContainer/Partida1/VBoxContainer/Nombrepartida1")
				if Global.Guardado[2]==true:
					$Button1.focus_neighbour_bottom=NodePath("../Button2")
				else: $Button1.focus_neighbour_bottom=NodePath("../MarginContainer/VBoxContainer/Partida3/VBoxContainer/Nombrepartida3")
			elif i==2:
				Game2.editable=false
				Game2.text=Global.Guardado_Texto[i]
				$Button2.set_deferred("disabled",false)
				$Button2.visible=true
				Fecha2.text=" "+String(Global.Fecha.fecha2.day)+"-"+String(Global.Fecha.fecha2.month)+"-"+String(Global.Fecha.fecha2.year) +" ("+ String(Global.Fecha.fecha2.hour)+":"+String(Global.Fecha.fecha2.minute)+")"
				$Borrado2.visible=true
				$Borrado2.set_deferred("disabled",false)
				var time=timeToHoursMin(int(Global.TimePlayed.time2))
				Timer2.text="Time Played: %02d:%02d" % [time[0],time[1]]
				if Global.Guardado[0]==true:
					$Button2.focus_neighbour_bottom=NodePath("../Button0")
				else: $Button2.focus_neighbour_bottom=NodePath("../MarginContainer/VBoxContainer/Partida1/VBoxContainer/Nombrepartida1")
				if Global.Guardado[1]==true:
					$Button2.focus_neighbour_top=NodePath("../Button1")
				else: $Button2.focus_neighbour_top=NodePath("../MarginContainer/VBoxContainer/Partida2/VBoxContainer/Nombrepartida2")
		else:
			if i==0:
				if Global.Guardado[1]==false:
					Game0.focus_neighbour_bottom=NodePath("../../../../../MarginContainer/VBoxContainer/Partida2/VBoxContainer/Nombrepartida2")
				if Global.Guardado[2]==false:
					Game0.focus_neighbour_top=NodePath("../../../../../MarginContainer/VBoxContainer/Partida3/VBoxContainer/Nombrepartida3")
			elif i==1:
				if Global.Guardado[0]==false:
					Game1.focus_neighbour_top=NodePath("../../../../../MarginContainer/VBoxContainer/Partida1/VBoxContainer/Nombrepartida1")
				if Global.Guardado[2]==false:
					Game1.focus_neighbour_bottom=NodePath("../../../../../MarginContainer/VBoxContainer/Partida3/VBoxContainer/Nombrepartida3")
			elif i==2:
				if Global.Guardado[0]==false:
					Game2.focus_neighbour_bottom=NodePath("../../../../../MarginContainer/VBoxContainer/Partida1/VBoxContainer/Nombrepartida1")
				if Global.Guardado[1]==false:
					Game2.focus_neighbour_top=NodePath("../../../../../MarginContainer/VBoxContainer/Partida2/VBoxContainer/Nombrepartida2")

func desaparecerPartida(numero):
	match numero:
		0:
			Game0.editable=true
			Game0.text=""
			$Button0.set_deferred("disabled",true)
			Fecha0.text=""
			Timer0.text=""
			$Borrado0.visible=false
			$Borrado0.set_deferred("disabled",true)
			$Button0.visible=false
			$Button0.modulate=Color(1,1,1,0.56)
		1:
			Game1.editable=true
			Game1.text=""
			$Button1.set_deferred("disabled",true)
			Fecha1.text=""
			Timer1.text=""
			$Borrado1.visible=false
			$Borrado1.set_deferred("disabled",true)
			$Button1.visible=false
			$Button1.modulate=Color(1,1,1,0.56)
		2:
			Game2.editable=true
			Game2.text=""
			$Button2.set_deferred("disabled",true)
			Fecha2.text=""
			Timer2.text=""
			$Borrado2.visible=false
			$Borrado2.set_deferred("disabled",true)
			$Button2.visible=false
			$Button2.modulate=Color(1,1,1,0.56)
	$AudioStreamPlayer2D.stream=load("res://Sonidos/Menu/DeleteSavedGame.wav")
	$AudioStreamPlayer2D.play()
	if Global.Guardado[0]==true:
		$Button0.grab_focus()
	else: Game0.grab_focus()
	$AudioStreamPlayer2D.stream=load("res://Sonidos/Menu/Elegir_Menu.wav")
	estado_partidas()

func timeToHoursMin(totalSeconds):
	var minutes=totalSeconds/60
	var hours=minutes/60
	return [hours, minutes]

func _on_Nombrepartida1_text_entered(new_text):
	if !new_text.empty():
		$AudioStreamPlayer2D.stream=load("res://Sonidos/Menu/Abrir_Menu.wav")
		$AudioStreamPlayer2D.play()
		var escena_Modo=load("res://UI/Menus/NormalONoHit.tscn")
		var escena=escena_Modo.instance()
		add_child(escena)
		yield(get_node("NormalONoHit"),"modeDecided")
		Game0.editable=false
		Global.Guardado[0]=true
		Global.Guardado_Texto[0]=new_text
		Global.Fecha.fecha0=OS.get_datetime()
		Global.guardar_ajustes()
		Global.guardar_partida(new_text,true)
		Global.partidaActiva=new_text
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		sonidoEntrarAPartidaGuardada(true)

func _on_Nombrepartida2_text_entered(new_text):
	if !new_text.empty():
		$AudioStreamPlayer2D.stream=load("res://Sonidos/Menu/Abrir_Menu.wav")
		$AudioStreamPlayer2D.play()
		var escena_Modo=load("res://UI/Menus/NormalONoHit.tscn")
		var escena=escena_Modo.instance()
		add_child(escena)
		yield(get_node("NormalONoHit"),"modeDecided")
		Game1.editable=false
		Global.Guardado[1]=true
		Global.Guardado_Texto[1]=new_text
		Global.Fecha.fecha1=OS.get_datetime()
		Global.guardar_ajustes()
		Global.guardar_partida(new_text,true)
		Global.partidaActiva=new_text
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		sonidoEntrarAPartidaGuardada(true)


func _on_Nombrepartida3_text_entered(new_text):
	if !new_text.empty():
		$AudioStreamPlayer2D.stream=load("res://Sonidos/Menu/Abrir_Menu.wav")
		$AudioStreamPlayer2D.play()
		var escena_Modo=load("res://UI/Menus/NormalONoHit.tscn")
		var escena=escena_Modo.instance()
		add_child(escena)
		yield(get_node("NormalONoHit"),"modeDecided")
		Game2.editable=false
		Global.Guardado[2]=true
		Global.Guardado_Texto[2]=new_text
		Global.Fecha.fecha2=OS.get_datetime()
		Global.guardar_ajustes()
		Global.guardar_partida(new_text,true)
		Global.partidaActiva=new_text
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		sonidoEntrarAPartidaGuardada(true)

func sonidoEntrarAPartidaGuardada(texto):
	$AudioStreamPlayer2D.stream=load("res://Sonidos/Menu/EnterSavedGame.wav")
	$AudioStreamPlayer2D.play()
	$AnimationPlayer.play("EntrarAJuego")
	yield(get_node("AnimationPlayer"),"animation_finished")
	if texto:
		get_tree().change_scene("res://UI/Menus/CinematicaInicial.tscn")
	else:
		get_tree().change_scene(Global.Escena)

func _on_Button0_pressed():
	Global.cargar_partida(Global.Guardado_Texto[0])
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	sonidoEntrarAPartidaGuardada(false)

func _on_Button1_pressed():
	Global.cargar_partida(Global.Guardado_Texto[1])
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	sonidoEntrarAPartidaGuardada(false)

func _on_Button2_pressed():
	Global.cargar_partida(Global.Guardado_Texto[2])
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	sonidoEntrarAPartidaGuardada(false)

func _on_Borrado0_pressed():
	$AbrirMenuDelete.play()
	cargarDeleteMenu(Global.Guardado_Texto[0],0)

func _on_Borrado1_pressed():
	$AbrirMenuDelete.play()
	cargarDeleteMenu(Global.Guardado_Texto[1],1)

func _on_Borrado2_pressed():
	$AbrirMenuDelete.play()
	cargarDeleteMenu(Global.Guardado_Texto[2],2)

func cargarDeleteMenu(nombre,numeroPartida):
	var escena=load("res://UI/Menus/DeleteFileMenu.tscn")
	var deleteMenu=escena.instance()
	deleteMenu.partida=nombre
	deleteMenu.connect("cierreMenu",self,"hoverGameFile",[numeroPartida])
	add_child(deleteMenu)

func hoverGameFile(numeroPartida):
	match numeroPartida:
		0: $Button0.grab_focus()
		1: $Button1.grab_focus()
		2: $Button2.grab_focus()

func _on_Button0_focus_entered():
	$AudioStreamPlayer2D.play()

func _on_Button0_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_Button1_focus_entered():
	$AudioStreamPlayer2D.play()

func _on_Button1_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_Button2_focus_entered():
	$AudioStreamPlayer2D.play()

func _on_Button2_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_Borrado0_focus_entered():
	$AudioStreamPlayer2D.play()

func _on_Borrado0_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_Borrado1_focus_entered():
	$AudioStreamPlayer2D.play()

func _on_Borrado1_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_Borrado2_focus_entered():
	$AudioStreamPlayer2D.play()

func _on_Borrado2_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_Nombrepartida3_text_changed(new_text):
	if OS.has_feature("mobile"):
		$MovilEmpezar2.visible=true
		$MovilEmpezar2.set_deferred("disabled",false)
	$Letras.play() 

func _on_Nombrepartida1_text_changed(new_text):
	if OS.has_feature("mobile"):
		$MovilEmpezar0.visible=true
		$MovilEmpezar0.set_deferred("disabled",false)
	$Letras.play() 

func _on_Nombrepartida2_text_changed(new_text):
	if OS.has_feature("mobile"):
		$MovilEmpezar1.visible=true
		$MovilEmpezar1.set_deferred("disabled",false)
	$Letras.play() 


func _on_MovilEmpezar0_pressed():
	_on_Nombrepartida1_text_entered($MarginContainer/VBoxContainer/Partida1/VBoxContainer/Nombrepartida1.text)
func _on_MovilEmpezar1_pressed():
	_on_Nombrepartida2_text_entered($MarginContainer/VBoxContainer/Partida2/VBoxContainer/Nombrepartida2.text)
func _on_MovilEmpezar2_pressed():
	_on_Nombrepartida3_text_entered($MarginContainer/VBoxContainer/Partida3/VBoxContainer/Nombrepartida3.text)

func _on_MovilEmpezar0_focus_entered():
	$AudioStreamPlayer2D.play()

func _on_MovilEmpezar0_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_MovilEmpezar1_focus_entered():
	$AudioStreamPlayer2D.play()

func _on_MovilEmpezar1_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_MovilEmpezar2_focus_entered():
	$AudioStreamPlayer2D.play()
func _on_MovilEmpezar2_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_Nombrepartida1_focus_entered():
	$AudioStreamPlayer2D.play()
func _on_Nombrepartida1_mouse_entered():
	$AudioStreamPlayer2D.play()
func _on_Nombrepartida2_focus_entered():
	$AudioStreamPlayer2D.play()
func _on_Nombrepartida2_mouse_entered():
	$AudioStreamPlayer2D.play()
func _on_Nombrepartida3_focus_entered():
	$AudioStreamPlayer2D.play()
func _on_Nombrepartida3_mouse_entered():
	$AudioStreamPlayer2D.play()
