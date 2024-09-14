extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.stop_song()
	Global.checkpoint=false
	Global.guardar_partida(Global.partidaActiva,false)
	Global.monstruosVisibleMenu.gorgona=true
	$AnimationPlayer.play("PrimerMensaje")
	yield(get_node("AnimationPlayer"),"animation_finished")
	$AnimationPlayer.play("EnterCicleIntermedioNivel1y2")
	if OS.has_feature("mobile"):
		usandoMando(true,"mobile")

func usandoMando(conectado,mobile):
	if conectado and mobile=="mobile":
		$PopUpsTutorial2/Enter2.texture=load("res://Tileset/Click.png")
		$PopUpsTutorial/Enter.texture=load("res://Tileset/Click.png")
	elif conectado:
		$PopUpsTutorial2/Enter2.texture=load("res://Tileset/EnterController.png")
		$PopUpsTutorial/Enter.texture=load("res://Tileset/EnterController.png")
	else:
		$PopUpsTutorial2/Enter2.texture=load("res://Tileset/Enter.png")
		$PopUpsTutorial/Enter.texture=load("res://Tileset/Enter.png")
func _process(delta):
	if not get_node("PopUpsTutorial/VideoPlayer").is_playing():
		get_node("PopUpsTutorial/VideoPlayer").play()

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		usandoMando(true,"mando")
	elif event is InputEventKey:
		usandoMando(false,"pc")
	if $PopUpsTutorial.visible and (event.is_action_pressed("ui_accept") or (event is InputEventScreenTouch and event.is_pressed())):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("SegundoMensaje")
		event.set_pressed(false)
		yield(get_node("AnimationPlayer"),"animation_finished")
		$AnimationPlayer.play("EnterCicleIntermedioNivel1y2")
	if $PopUpsTutorial2.visible and (Input.is_action_just_pressed("ui_accept") or (event is InputEventScreenTouch and event.is_pressed())):
		get_tree().change_scene("res://Escenas/Nivel 2/Nivel2.tscn")
