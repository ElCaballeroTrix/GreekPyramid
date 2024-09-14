extends Area2D


var move=Vector2.ZERO
var direccion=Vector2.ZERO
var speed=3
var sprite="default"
var sonido
var colors = ["eb7003","3527dd","27dd48"]
export(int, "Normal","Blue", "Green") var colorOfFire

func _ready():
	$Particles2D.modulate = Color(colors[colorOfFire])
	if OS.has_feature("mobile"):
		$Particles2d/Light2D.visible=false
	$AudioStreamPlayer2D.play()

func _physics_process(delta):
	move=Vector2.ZERO
	move=move.move_toward(direccion,delta)
	move=move.normalized()*speed
	position+=move

func _on_Fireball_area_entered(area):
	queue_free()

func _on_Fireball_body_entered(body):
	queue_free()
