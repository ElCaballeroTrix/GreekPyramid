extends Area2D


export(Vector2) var tp_pos


func _on_Tp_body_entered(body):
	$AnimationPlayer.play("Fadeinout")
	yield(get_tree().create_timer(0.2),"timeout")
	body.position=tp_pos
