extends Area2D

const HitEffect=preload("res://Escenas/HitEffect.tscn")
var knockback_vector=Vector2.ZERO
onready var collisionshape=$CollisionShape2D

signal invincibility_started
signal invincibility_ended
	

func create_hit_effect():
	var effect=HitEffect.instance()
	var main=get_tree().current_scene
	main.add_child(effect)
	effect.global_position=global_position

func start_invincibility(duration):
	emit_signal("invincibility_started")
	$Timer.start(duration)

func _on_Timer_timeout():
	$Timer.stop()
	emit_signal("invincibility_ended")

func _on_Hurtbox_invincibility_started():
	collisionshape.set_deferred("disabled",true)

func _on_Hurtbox_invincibility_ended():
	collisionshape.disabled=false
