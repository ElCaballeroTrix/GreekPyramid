extends KinematicBody2D

export (String, FILE, "*.tscn") var escena
export var irAOtraEscena=true
export var mensajeSePuedeVer=true
func _ready():
	if OS.has_feature("mobile"):
		usandoMando(true,"mobile")

func usandoMando(conectado,mobile):
	if conectado and mobile=="mobile":
		$SpriteEnter.texture=load("res://Tileset/Click.png")
	elif conectado:
		$SpriteEnter.texture=load("res://Tileset/EnterController.png")
	else:
		$SpriteEnter.texture=load("res://Tileset/Enter.png")
func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		usandoMando(true,"mando")
	elif event is InputEventKey:
		usandoMando(false,"pc")

func _on_Dialogo_finalice():
	$CanvasLayer/Dialogo.dentro=false
	$AudioStreamPlayer2D.play()
	mensajeSePuedeVer=true
	if irAOtraEscena:
		$AnimationPlayer.play("Transicion")
		yield(get_node("AnimationPlayer"),"animation_finished")
		get_tree().change_scene(escena)


func _on_ZonaDeDialogo_body_entered(body):
	if body.name=="Jugador" and mensajeSePuedeVer:
		$AnimationPlayer.play("Mensaje")


func _on_ZonaDeDialogo_body_exited(body):
	if body.name=="Jugador" and mensajeSePuedeVer:
		$AnimationPlayer.play("Fin_Mensaje")
