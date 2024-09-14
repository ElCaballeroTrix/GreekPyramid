extends KinematicBody2D


onready var stats=$Stats
var attack=false
export var speed=90
export var accelaration=200
export var initialPoint=Vector2.ZERO
export var point=Vector2.ZERO
export var limit=0
export (String) var rutaJugador
onready var Jugador=get_tree().get_root().get_node(rutaJugador)
var velocidad=Vector2.ZERO
var subiendo=true
func _ready():
	Jugador.connect("comienzaStunGorgona",self,"estuneado")
	Jugador.connect("acabaStunGorgona",self,"finestuneado")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (int(round(global_position.y))==initialPoint.y || int(round(global_position.y))==limit) && !subiendo:
		$AnimationPlayer.play("SalirDelEscenario")
		$AnimatedSprite.stop()
		$AnimatedSprite.frame=0
	if global_position.y<=point.y+2 && global_position.y>=point.y-2:
		attack=false
		$AnimatedSprite.rotation_degrees=-90
		var direccion=global_position.direction_to(initialPoint)
		velocidad=velocidad.move_toward(direccion * speed,accelaration * delta)
		velocidad.y=120
	if attack:
		subiendo=false
		var direccion=global_position.direction_to(point)
		velocidad=velocidad.move_toward(direccion * speed,accelaration * delta)
		velocidad.y=-120
	velocidad=move_and_slide(velocidad)


func _on_Stats_no_health():
	$Hurtbox.create_hit_effect()
	queue_free()


func _on_Hurtbox_invincibility_started():
	$BlinkAnimation.play("BlinkEnemigoVaYVuelve")


func _on_Hurtbox_invincibility_ended():
	$BlinkAnimation.play("StopBlinkEnemigoVaYVuelve")


func _on_Hurtbox_area_entered(area):
	stats.health-=area.damage
	$Hurtbox.start_invincibility(0.4)


func _on_Timer_timeout():
	$AnimationPlayer.play("Salir")

func move():
	attack=true
	$AnimatedSprite.play("default")

func start_over():
	$AnimatedSprite.rotation_degrees=90
	subiendo=true
	$Timer.start()

func estuneado(cuerpo):
	if self==cuerpo:
		$AnimatedSprite.material.shader=load("res://Shaders/Piedra.shader")
func finestuneado():
	$AnimatedSprite.material.shader=load("res://Shaders/Blink.shader")
