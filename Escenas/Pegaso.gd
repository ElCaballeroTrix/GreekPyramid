extends KinematicBody2D

export var pegasoMovible=false
export var speed=300
export var gravedad=98
var direccion=Vector2()
var direccionNS=0
var distancia=Vector2()
var velocidad=Vector2()
var pocos_Corazones=false
export var hearts=4
signal muriendo()
signal dead()

func _ready():
	if !pegasoMovible:
		set_physics_process(false)
		$CanvasLayer/Hearts.visible=false
	else:
		$CanvasLayer/Hearts/HeartsFull.texture.pause=true
		$CanvasLayer/Hearts/HeartsFull.texture.current_frame=0
		$AnimacionPegaso.play("CorreConJugadorPegaso")


func _physics_process(delta):
	direccion.x= int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	direccion.y= int(Input.is_action_pressed("mirar_abajo"))-int(Input.is_action_pressed("mirar_arriba"))
	direccion=direccion.normalized()
	distancia.x=speed*delta
	velocidad.x=distancia.x*direccion.x/delta
	velocidad.y=speed*delta*direccion.y/delta
#	velocidad.y += gravedad*delta
#	velocidad.y=min(250, velocidad.y)
	velocidad=move_and_slide(velocidad,Vector2(0,-1),false,4,PI/4,false)


func _on_TimerHearts_timeout():
	if !pocos_Corazones:
		$CanvasLayer/Hearts/HeartsFull.texture.oneshot=false
		$CanvasLayer/Hearts/HeartsFull.texture.pause=false
		pararAnimacion()


func pararAnimacion():
	yield(get_tree().create_timer(0.85),"timeout")
	$CanvasLayer/Hearts/HeartsFull.texture.current_frame=0
	$CanvasLayer/Hearts/HeartsFull.texture.oneshot=false
	$CanvasLayer/Hearts/HeartsFull.texture.pause=true


func _on_Hurtbox_area_entered(area):
	hearts-=1
	$AudioLatido.stream=load("res://Sonidos/Pegaso/PegasoDolor.wav")
	$AudioLatido.play()
	$Hurtbox.start_invincibility(1)
	if hearts==0:
		emit_signal("muriendo")
		Global.playerDeadSong()
		dead()
	else:
			$CanvasLayer/Hearts/HeartsFull.rect_size.x=hearts*9
	if hearts==1:
		#Si el jugador solo tiene un corazón, los corazones vibran, pantalla roja, y latido
		pocos_Corazones=true
		$CanvasLayer/Hearts/HeartsEmpty.material.set_shader_param("onoff",0)
		$CanvasLayer/Hearts/HeartsFull.material.set_shader_param("onoff",0)
		$AnimacionLatido.play("LatidoPegaso")

func dead():
	$AudioLatido.stream=load("res://Sonidos/Pegaso/PegasoDolor.wav")
	$AudioLatido.play()
	$AnimacionLatido.stop()
	$AnimacionLatido.seek(0.0,true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled",true)
	set_collision_layer_bit(1,false)
	velocidad.x=0
	velocidad.y=0
	velocidad=move_and_slide(velocidad,Vector2(0,1))
	$AnimacionPegaso.play("MuertoPegaso")
	$Hurtbox.collision_layer=false

func derrotado():
	emit_signal("dead")

func _on_Hurtbox_invincibility_started():
	$AnimationBlinkPegaso.play("BlinkPegaso")

func _on_Hurtbox_invincibility_ended():
	$AnimationBlinkPegaso.play("StopBlinkPegaso")
