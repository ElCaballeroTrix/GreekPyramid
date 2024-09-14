extends Node2D

onready var buttonAttack=$MarginContainer/HBoxContainer/PC/ControllesPC/ControlButtonAttack
onready var buttonRoll=$MarginContainer/HBoxContainer/PC/ControllesPC/ControlButtonRodar
onready var buttonJump=$MarginContainer/HBoxContainer/PC/ControllesPC/ControlButtonJump
onready var buttonLeft=$MarginContainer/HBoxContainer/PC/ControllesPC/ControlButtonMoveLeft
onready var buttonRight=$MarginContainer/HBoxContainer/PC/ControllesPC/ControlButtonMoveRight
onready var buttonDown=$MarginContainer/HBoxContainer/PC/ControllesPC/ControlButtonDown
onready var buttonUp=$MarginContainer/HBoxContainer/PC/ControllesPC/ControlButtonUp
onready var buttonAbility=$MarginContainer/HBoxContainer/PC/ControllesPC/ControlButtonHabilidad
onready var buttonMenu=$MarginContainer/HBoxContainer/PC/ControllesPC/ControlButtonMenu
signal cierreMenu()
# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/Controles/MarginContainer7.rect_position.y=290
	$MarginContainer/HBoxContainer/Controles/Menu.rect_position.y=290
	$MarginContainer/HBoxContainer/PC/TileMap.position.y=-4
	$Salir.grab_focus()
	if OS.has_feature("mobile"):
		$MarginContainer/HBoxContainer/PC/TileMap.visible=true
		$MarginContainer/HBoxContainer/PC/ControllesPC.visible=false
	else:
		$MarginContainer/HBoxContainer/PC/TileMap.visible=false
		$MarginContainer/HBoxContainer/PC/ControllesPC.visible=true
		buttonAttack.rect_position=Vector2(30,30)
		buttonRoll.rect_position=Vector2(30,68)
		buttonJump.rect_position=Vector2(30,106)
		buttonLeft.rect_position=Vector2(6,144)
		buttonRight.rect_position=Vector2(58,144)
		buttonDown.rect_position=Vector2(58,182)
		buttonUp.rect_position=Vector2(6,182)
		buttonAbility.rect_position=Vector2(30,220)
		buttonMenu.rect_position=Vector2(30,266)
		
		buttonAttack.connect("cambioAcabado",self,"controlCambio")
		buttonRoll.connect("cambioAcabado",self,"controlCambio")
		buttonJump.connect("cambioAcabado",self,"controlCambio")
		buttonLeft.connect("cambioAcabado",self,"controlCambio")
		buttonRight.connect("cambioAcabado",self,"controlCambio")
		buttonDown.connect("cambioAcabado",self,"controlCambio")
		buttonUp.connect("cambioAcabado",self,"controlCambio")
		buttonAbility.connect("cambioAcabado",self,"controlCambio")
		buttonMenu.connect("cambioAcabado",self,"controlCambio")

func _input(event):
	if event.is_action_pressed("ui_cancel") || event.is_action_pressed("menu"):
		cerrarMenu()

func _process(delta):
	#$Salir.grab_focus()
	pass

func cerrarMenu():
	Global.Sali_Menu=true
	emit_signal("cierreMenu")
	queue_free()

func controlCambio(controlCambiado):
	controlCambiado.grab_focus()

func _on_Salir_pressed():
	cerrarMenu()

func _on_Salir_focus_entered():
	$AudioStreamPlayer2D.play()

func _on_Salir_mouse_entered():
	$AudioStreamPlayer2D.play()
