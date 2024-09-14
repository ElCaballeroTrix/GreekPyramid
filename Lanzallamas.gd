extends Node2D


export var tiempoBucle = 1.9
export var tiempoDescanso = 3
var colors = ["ffffff","3527dd","27dd48"]
export(int, "Normal","Blue", "Green") var colorOfFire
var enBucle = false

func _ready():
	$Sprite.modulate = Color(colors[colorOfFire])

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"StartFire":
			$AnimationPlayer.play("FireLoop")
			$Timer.start(tiempoBucle)
			enBucle = true
		"EndFire": $Timer.start(tiempoDescanso)


func _on_Timer_timeout():
	if !enBucle:
		$AnimationPlayer.play("StartFire")
	else: 
		$AnimationPlayer.play("EndFire")
		enBucle = false
