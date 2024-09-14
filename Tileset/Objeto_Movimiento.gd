extends RigidBody2D

onready var Jugador=get_tree().get_root().get_node("2Parte_Nivel_1/Jugador")
onready var Jugador_Idle=get_tree().get_root().get_node("2Parte_Nivel_1/Jugador/AnimationPlayer")
onready var Camera=get_tree().get_root().get_node("2Parte_Nivel_1/Tronco/AnimationPlayer")
export var posicionY=0
var cayendo=false
func _ready():
	pass

func _process(delta):
	if !cayendo:
		position.y=posicionY
		if linear_velocity.x!=0 :
			if !$SonidoSplash.is_playing():
				$SonidoSplash.play()
		else: $SonidoSplash.stop()

func _on_Objeto_Movil_body_entered(body):
	if body.name=="Fin_Tronco":
		$SonidoSplash.stop()
		cayendo=true
		gravity_scale=3
		set_linear_velocity(Vector2(0,0))
		body.queue_free()
		Jugador.set_physics_process(false)
		Jugador_Idle.play("Idle")
		Camera.play("Tronco_Cayendo")
		yield(get_tree().create_timer(1),"timeout")
		mode=RigidBody2D.MODE_STATIC
		Jugador.set_physics_process(true)
