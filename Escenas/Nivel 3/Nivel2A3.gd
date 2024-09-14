extends Node2D

var canBackGroundMove=true
var randomSpawn
var randomNumberOfBirds
var randomSpawnUp
var randomNumberOfBirdsUp
var randomSpawnLeft
var randomNumberOfBirdsLeft
var section=0

onready var escenaPajaro=load("res://Escenas/FlyingStraightCreature.tscn")

func _ready():
	if OS.has_feature("mobile"):
		$MobileControls/MobileButtons/DPAD.visible=true
		$MobileControls/MobileButtons/Up.visible=true
		$MobileControls/MobileButtons/Down.visible=true
		$MobileControls/MobileButtons/Right.visible=true
		$MobileControls/MobileButtons/Left.visible=true
		$MobileControls/MobileButtons/Menu.visible=true
		$MobileControls/MobileButtons/Ability.visible=false
		$MobileControls/MobileButtons/Roll.visible=false
		$MobileControls/MobileButtons/Attack.visible=false
		$MobileControls/MobileButtons/Jump.visible=false
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.stop_song()
	Global.guardar_partida(Global.partidaActiva,false)
	Global.play_song("res://Sonidos/Musica/Nivel2A3Musica.wav")
	Global.checkpoint=false
	$Pegaso.set_physics_process(false)
	$Viento/VientoIzquierda/AudioIzquierda.stream=load("res://Sonidos/Ambiente/VientoSinRetardo.wav")
	$Viento/VientoIzquierda/AudioIzquierda.play()

func _process(delta):
	if canBackGroundMove:
		$ParallaxBackground.scroll_base_offset.x-=100*delta


func _on_Animatione_animation_finished(anim_name):
	if anim_name=="Entrada":
		$Pegaso.set_physics_process(true)


func _on_Pegaso_dead():
	get_tree().change_scene("res://Escenas/Nivel 3/Nivel2A3.tscn")

func _on_Pegaso_muriendo():
	$Pegaso.set_physics_process(false)
	canBackGroundMove=false

func _on_PauseMenu_reinicio():
	if $Pegaso/AnimacionLatido.is_playing():
		$Pegaso/AnimacionLatido.stop()
		$Pegaso/AnimacionLatido.seek(0.0,true)
	get_tree().change_scene("res://Escenas/Nivel 3/Nivel2A3.tscn")

func _on_TimerSecciones_timeout():
	section+=1
	if section==1:
		$TimerSpawnLado.stop()
		$TimerSpawnLado2.stop()
		$TimerSecciones.start(8)
		$Viento/VientoIzquierda/AudioIzquierda.stream=load("res://Sonidos/Ambiente/Viento.wav")
		$Viento/VientoIzquierda/AudioIzquierda.play()
	elif section==2:
		$TimerSecciones.start(32)
		$TimerSpawnArriba.start()
	elif section==3:
		$TimerSpawnArriba.stop()
		$TimerSpawnArriba2.stop()
		$TimerSecciones.start(8)
		$Viento/VientoIzquierda/AudioIzquierda.stream=load("res://Sonidos/Ambiente/VientoIzquierda.wav")
		$Viento/VientoIzquierda/AudioIzquierda.play()
	elif section==4:
		$TimerSecciones.start(33)
		$TimerSpawnIzquierdo.start()
	elif section==5:
		$TimerSpawnIzquierdo.stop()
		$TimerSpawnIzquierdo2.stop()
		$TimerSecciones.start(8)
		$Viento/VientoIzquierda/AudioIzquierda.play()
		$Viento/VientoIzquierda/Audio2.play()
	elif section==6:
		$TimerSecciones.start(15)
		$TimerSpawnLado.start()
		$TimerSpawnIzquierdo.start()
	elif section==7:
		$TimerSecciones.start(4)
		$TimerSpawnLado.stop()
		$TimerSpawnIzquierdo.stop()
	else:
		$Pegaso.set_physics_process(false)
		if $Pegaso/AnimacionLatido.is_playing():
			$Pegaso/AnimacionLatido.stop()
			$Pegaso/AnimacionLatido.seek(0.0,true)
		var animacionSalida=AnimationPlayer.new()
		add_child(animacionSalida)
		var bajar=Animation.new()
		animacionSalida.add_animation("Bajar",bajar)
		bajar.add_track(0)
		bajar.length=2
		var ruta=String($Pegaso.get_path())+":position"
		bajar.track_set_path(0,ruta)
		bajar.track_insert_key(0,0.0,$Pegaso.global_position)
		bajar.track_insert_key(0,2.0,Vector2(896,448))
		animacionSalida.play("Bajar")
		Global.facedOutSong()
		$Animatione.play("EntradaANivel3")

func _on_TimerSpawnLado_timeout():
	var randomNumber
	if section==0:
		randomNumber=[1,2,3,4,5,6]
	else: randomNumber=[1,2,3,4]
	randomNumberOfBirds=randomNumber[randi()% randomNumber.size()]
	randomNumber.shuffle()
	randomSpawn=randomNumber.duplicate()
	var pajaro=escenaPajaro.instance()
	pajaro.spriteAnim="PajaroBlancoLado"
	pajaro.spriteFlip=true
	pajaro.vectorDireccion=Vector2(-5,0)
	add_child(pajaro)
	pajaro.global_position=$SpawnsDerecha.get_child(randomSpawn.pop_front()-1).position
	if randomNumberOfBirds==1:
		randomNumberOfBirds+=1
	if randomNumberOfBirds==6 && section==0:
		randomNumberOfBirds=5
	elif randomNumberOfBirds==4:
		randomNumberOfBirds=3
	$TimerSpawnLado2.start(0.2)

func _on_TimerSpawnLado2_timeout():
	var pajaro=escenaPajaro.instance()
	pajaro.spriteAnim="PajaroBlancoLado"
	pajaro.spriteFlip=true
	pajaro.vectorDireccion=Vector2(-5,0)
	add_child(pajaro)
	pajaro.global_position=$SpawnsDerecha.get_child(randomSpawn.pop_front()-1).position
	randomNumberOfBirds-=1
	if randomNumberOfBirds!=0:
		$TimerSpawnLado2.start(0.2)


func _on_TimerSpawnArriba_timeout():
	var randomNumberUp=[1,2,3,4,5,6,7,8]
	randomNumberOfBirdsUp=randomNumberUp[randi()% randomNumberUp.size()]
	randomNumberUp.shuffle()
	randomSpawnUp=randomNumberUp.duplicate()
	var pajaro=escenaPajaro.instance()
	pajaro.spriteAnim="PajaroBlancoArriba"
	pajaro.vectorDireccion=Vector2(0,5)
	add_child(pajaro)
	pajaro.global_position=$SpawnsArriba.get_child(randomSpawnUp.pop_front()-1).position
	if randomNumberOfBirdsUp==1:
		randomNumberOfBirdsUp+=1
	if randomNumberOfBirdsUp==8:
		randomNumberOfBirdsUp=7
	$TimerSpawnArriba2.start(0.2)

func _on_TimerSpawnArriba2_timeout():
	var pajaro=escenaPajaro.instance()
	pajaro.spriteAnim="PajaroBlancoArriba"
	pajaro.vectorDireccion=Vector2(0,5)
	add_child(pajaro)
	pajaro.global_position=$SpawnsArriba.get_child(randomSpawnUp.pop_front()-1).position
	randomNumberOfBirdsUp-=1
	if randomNumberOfBirdsUp!=0:
		$TimerSpawnArriba2.start(0.2)

func _on_PajarosDesaparecenArriba_area_entered(area):
	area.get_parent().queue_free()
func _on_PajarosDesaparecenDerecha_area_entered(area):
	area.get_parent().queue_free()
func _on_PajarosDesaparecenIzquierda_area_entered(area):
	area.get_parent().queue_free()


func _on_TimerSpawnIzquierdo_timeout():
	var randomNumberLeft
	if section==4:
		randomNumberLeft=[1,2,3,4,5]
	else:randomNumberLeft=[1,2,3]
	randomNumberOfBirdsLeft=randomNumberLeft[randi()% randomNumberLeft.size()]
	randomNumberLeft.shuffle()
	randomSpawnLeft=randomNumberLeft.duplicate()
	var pajaro=escenaPajaro.instance()
	pajaro.spriteAnim="PajaroNegroLado"
	pajaro.spriteFlip=false
	pajaro.vectorDireccion=Vector2(5,0)
	add_child(pajaro)
	pajaro.global_position=$SpawnsIzquierda.get_child(randomSpawnLeft.pop_front()-1).position
	if randomNumberOfBirdsLeft==1:
		randomNumberOfBirdsLeft+=1
	if randomNumberOfBirdsLeft==5 && section==4:
		randomNumberOfBirdsLeft=4
	elif randomNumberOfBirdsLeft==3:
		randomNumberOfBirdsLeft=2
	$TimerSpawnIzquierdo2.start(0.2)

func _on_TimerSpawnIzquierdo2_timeout():
	var pajaro=escenaPajaro.instance()
	pajaro.spriteAnim="PajaroNegroLado"
	pajaro.spriteFlip=false
	pajaro.vectorDireccion=Vector2(5,0)
	add_child(pajaro)
	pajaro.global_position=$SpawnsIzquierda.get_child(randomSpawnLeft.pop_front()-1).position
	randomNumberOfBirdsLeft-=1
	if randomNumberOfBirdsLeft!=0:
		$TimerSpawnIzquierdo2.start(0.2)


func teletransporteANivel3():
	get_tree().change_scene("res://Escenas/Nivel 3/Nivel3.tscn")
