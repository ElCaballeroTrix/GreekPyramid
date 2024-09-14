extends KinematicBody2D


onready var stats=$Stats
enum {
	DASH,
	IDLE
}
var state=IDLE
var velocity=Vector2.ZERO
export var sonidoCorriendo=""
export var sonido=""
export var speed=200
export var direction=1
export (String) var rutaJugador
onready var Jugador=get_tree().get_root().get_node(rutaJugador)
signal dead()

func _ready():
	Jugador.connect("comienzaStunGorgona",self,"estuneado")
	Jugador.connect("acabaStunGorgona",self,"finestuneado")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Se queda quieto unos segundos con en idle, cuando acaba, dashea hasta el final
	if velocity!=Vector2.ZERO && !$AudioStreamPlayer2D.is_playing():
		$AudioStreamPlayer2D.stream=load(sonidoCorriendo)
		$AudioStreamPlayer2D.play()
	match state:
			IDLE:
				idle()
			DASH:
				dash(delta)

func idle():
	$AnimationPlayer.play("IdleEnemigoConDash") 
	velocity=Vector2.ZERO

func dash(delta):
	$AnimationPlayer.play("DashEnemigoConDash")
	velocity.x=(speed*delta*direction)/delta
	velocity.y=0
	velocity=move_and_slide(velocity,Vector2(0,-1))

func _on_Hurtbox_invincibility_started():
	$BlinkAnimation.play("BlinkEnemigoConDash")


func _on_Hurtbox_invincibility_ended():
	$BlinkAnimation.play("StopBlinkEnemigoConDash")


func _on_Hurtbox_area_entered(area):
	stats.health-=area.damage
	$Hurtbox.start_invincibility(0.4)


func _on_Timer_timeout():
	$AudioStreamPlayer2D.stream=load(sonido)
	$AudioStreamPlayer2D.play()
	yield(get_node("AudioStreamPlayer2D"),"finished")
	state=DASH


func _on_Stats_no_health():
	$Hurtbox.create_hit_effect()
	emit_signal("dead")
	queue_free()


func _on_WallDetector_body_entered(body):
	if body.name=="Limit" || body.name=="Limit2":
		$AudioStreamPlayer2D.stop()
		if direction==1:
			$Sprite.flip_h=false
			direction=-1
		else:
			$Sprite.flip_h=true
			direction=1
		state=IDLE
		$Timer.start()

func estuneado(cuerpo):
	if self==cuerpo:
		$Sprite.material.shader=load("res://Shaders/Piedra.shader")
		$AnimationPlayer.stop(false)
func finestuneado():
	$Sprite.material.shader=load("res://Shaders/Blink.shader")
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play()
