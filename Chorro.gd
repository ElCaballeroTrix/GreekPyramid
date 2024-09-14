extends Area2D

export var tiempoBucle=5
export var tiempoReposo=2
export var rotacion=0.1
onready var timer=$Timer
onready var timer2=$Timer2

func _ready():
	timer.connect("timeout",self,"reiniciarBucle")
	timer2.connect("timeout",self,"finBucle")
	reiniciarBucle()

func _process(delta):
	$Objeto_Pupa/ObjetoEncima.rotation+=rotacion
	$StaticBody2D.constant_linear_velocity=Vector2(0,980)

func finBucle():
	timer2.stop()
	$AnimationPlayer.stop()
	$Sprite2.visible=false 
	$Sprite.visible=true
	$AnimationPlayer.play_backwards("ChorroAnimacionInicio")
	$Sprite/AudioChorro.stream=load("res://Sonidos/Nivel2/ChorroInicioAlReves.wav")
	$Sprite/AudioChorro.play()
	yield(get_node("AnimationPlayer"),"animation_finished")
	timer.start(tiempoReposo)

func reiniciarBucle():
	timer.stop()
	$AnimationPlayer.stop()
	$Sprite2.visible=false
	$Sprite.visible=true
	$AnimationPlayer.play("ChorroAnimacionInicio")
	$Sprite/AudioChorro.stream=load("res://Sonidos/Nivel2/ChorroInicio.wav")
	$Sprite/AudioChorro.play()
	yield(get_node("AnimationPlayer"),"animation_finished")
	$Sprite.visible=false
	$Sprite2.visible=true
	$AnimationPlayer.play("BucleChorro")
	timer2.start(tiempoBucle)
