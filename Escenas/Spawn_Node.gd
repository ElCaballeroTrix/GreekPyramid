extends Node2D


export (String) var animation1
export (String) var animation2
var numero=1
onready var timer=$Spawn/Timer
onready var stats=$Stats

func _process(delta):
	if animation1!="" && timer.time_left>0.4  && timer.time_left<0.5:
		$AnimationPlayer.stop()
		$AnimationPlayer.play(animation2)
		yield(get_node("AnimationPlayer"),"animation_finished")
		$AnimationPlayer.play(animation1)


func _on_Hurtbox_invincibility_started():
	$BlinkAnimationPlayer.play("StartBlinkSpawn")

func _on_Hurtbox_invincibility_ended():
	$BlinkAnimationPlayer.play("StopBlinkSpawn")

func _on_Stats_no_health():
	$Hurtbox.create_hit_effect()
	queue_free()

func _on_Hurtbox_area_entered(area):
	stats.health-=area.damage
	$Hurtbox.start_invincibility(0.5)


func _on_Hitbox_area_entered(area):
	if area.name=="Stun_Gorgona":
		#Puede que haga falta parar la animación
		$Spawn/Timer.stop()
		set_process(false)
		$Sprite.material.shader=load("res://Shaders/Piedra.shader")
		$AnimationPlayer.stop(false)
		var timer=Timer.new()
		timer.connect("timeout",self,"quitarStun")
		add_child(timer) 

func quitarStun():
		$Spawn/Timer.start()
		set_process(true)
		$Sprite.material.shader=load("res://Shaders/Blink.shader")
		$AnimationPlayer.play()
