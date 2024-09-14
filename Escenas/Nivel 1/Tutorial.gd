extends Node2D


func _ready():
	if OS.has_feature("mobile"):
		usandoMando(true,"mobile")
		$Luz.visible=false
		$SpritesMando.visible=false
		$TileMapControles.visible=false
		$SpritesMovil.visible=true
		$CanvasLayer/PopUpsTutorial/VideoPlayer.stream=load("res://Videos/TutorialMovil.ogv")
	else: 
		$SpritesMovil.visible=false
		$CanvasLayer/PopUpsTutorial/VideoPlayer.stream=load("res://Videos/TutorialAtacar.ogv")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.nombre_audio_suelo="Piedra"
	Global.nombre_carpeta_suelo="Piedra"
	Global.play_song("res://Sonidos/Musica/CaveSound.wav")
	$Jugador.set_physics_process(false)
	$AnimationPlayer.play("PopUpShows")
	yield(get_node("AnimationPlayer"),"animation_finished")
	$AnimationPlayer.play("EnterCicle")
	

func usandoMando(conectado,mobile):
	if conectado and mobile=="mobile":
		$CanvasLayer/PopUpsTutorial2/Enter.texture=load("res://Tileset/Click.png")
		$CanvasLayer/PopUpsTutorial/Enter.texture=load("res://Tileset/Click.png")
	elif conectado:
		$CanvasLayer/PopUpsTutorial2/Enter.texture=load("res://Tileset/EnterController.png")
		$CanvasLayer/PopUpsTutorial/Enter.texture=load("res://Tileset/EnterController.png")
	else:
		$CanvasLayer/PopUpsTutorial2/Enter.texture=load("res://Tileset/Enter.png")
		$CanvasLayer/PopUpsTutorial/Enter.texture=load("res://Tileset/Enter.png")

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		usandoMando(true,"mando")
	elif event is InputEventKey:
		usandoMando(false,"pc")
	if $CanvasLayer/PopUpsTutorial2.visible and (event.is_action_pressed("ui_accept") or (event is InputEventScreenTouch and event.is_pressed())):
		$AnimationPlayer.play("Inicio")
		yield(get_node("AnimationPlayer"),"animation_finished")
		$Jugador.set_physics_process(true)
	if $CanvasLayer/PopUpsTutorial.visible==true and (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("attack") or (event is InputEventScreenTouch and event.is_pressed())):
		$AnimationPlayer.stop()
		$CanvasLayer/PopUpsTutorial.visible=false
		#$Area2D/CollisionShape2D.set_deferred("disabled",true)
		$Jugador.set_physics_process(true)

func _on_Area2D_body_entered(body):
	if body.name=="Jugador":
		$CanvasLayer/PopUpsTutorial.visible=true
		$CanvasLayer/PopUpsTutorial/VideoPlayer.paused=false
		$CanvasLayer/PopUpsTutorial/VideoPlayer.play()
		$AnimationPlayer.play("EnterCicle")
		$Jugador.set_physics_process(false)
		$Jugador/AnimationPlayer.play("Idle")

func _process(delta):
	if not get_node("CanvasLayer/PopUpsTutorial/VideoPlayer").is_playing():
		get_node("CanvasLayer/PopUpsTutorial/VideoPlayer").play()

func _on_PauseMenu_reinicio():
	PlayerStats.health=PlayerStats.max_health
	PlayerStats.recuperoVida()
	$Jugador/Sprite.material.set('shader_param/active',false)
	get_tree().reload_current_scene()

func _on_Dialogo_finalice():
	PlayerStats.set_max_health(8)
	PlayerStats.set_health(8)
	PlayerStats.recuperoVida()
	$Jugador.set_physics_process(false)
	$Jugador/CanvasLayer/HealthUI.visible=false
	$AnimationPlayer.play("Transicion")


func _on_Jugador_teletransporte_muerto():
	get_tree().reload_current_scene()
