extends KinematicBody2D

var x_speed=150
var y_speed=-30
var gravity=400
var velocity=Vector2.ZERO
var direccion=Vector2.ZERO

export var sprite="BolaSangre"


# Called when the node enters the scene tree for the first time.
func _ready():
	#velocity=Vector2(x_speed,y_speed)
	var capsulaHitbox
	var capsulaColision
	match sprite:
		"BolaSangre":
			$Sprite.texture=load("res://Enemigos/Nivel2/BolaSangre.png")
			capsulaHitbox=CircleShape2D.new()
			capsulaHitbox.radius=2.5
			capsulaColision=CircleShape2D.new()
			capsulaColision.radius=2
			$CollisionShape2D.rotation=0
			$Hitbox/CollisionShape2D.rotation=0
			$Sprite.scale=Vector2(0.4,0.4)
		"LanzaMomia":
			$Sprite.texture=load("res://Enemigos/Nivel3/LanzaMomia.png")
			capsulaHitbox=CapsuleShape2D.new()
			capsulaHitbox.radius=0.5
			capsulaHitbox.height=20
			capsulaColision=CapsuleShape2D.new()
			capsulaColision.radius=0.5
			capsulaColision.height=1
			$Sprite.scale=Vector2(1,1)
	$Hitbox/CollisionShape2D.shape=capsulaHitbox
	$CollisionShape2D.shape=capsulaColision
	set_physics_process(false)
	fire()


func _physics_process(delta):
	self.rotation_degrees+=300*delta
	#velocity=velocity.move_toward(x_speed*direccion,200*delta)
	velocity.y+=gravity*delta
	move_and_slide(velocity)
#	self.rotation=0.1
	var angle=atan2(velocity.y,velocity.x)
	self.rotation=angle

func fire():
	direccion+=Vector2(rand_range(0,16),rand_range(0,16))
	var altura=direccion.y-global_position.y-32
	altura=min(altura,-32)
	velocity=calcular_velocidad(global_position,direccion,altura)
	velocity=velocity.clamped(1000)
	set_physics_process(true)

func calcular_velocidad(punto_inicial,punto_final,altura, \
		up_gravity=gravity,down_gravity=null):
	
	if down_gravity==null:
		down_gravity=up_gravity
	var velocidad=Vector2()
	var desplazamiento=punto_final-punto_inicial
	
	if desplazamiento.y>altura:
		var tiempoUp=sqrt(-2*altura/float(up_gravity))
		var tiempoDown=sqrt(2*(desplazamiento.y-altura)/float(down_gravity))
		velocidad.y=-sqrt(-2*up_gravity*altura)
		velocidad.x=desplazamiento.x/float(tiempoUp+tiempoDown)
	
	return velocidad

func _on_Hitbox_area_entered(area):
	queue_free()

func _on_Hitbox_body_entered(body):
	if body.name != "ProyectilConCurva" && body.get_parent().name!="EnemigoEscupeConCurva":
		queue_free()
