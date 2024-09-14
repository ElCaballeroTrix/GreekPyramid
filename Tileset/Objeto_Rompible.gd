extends StaticBody2D


var auxiliar=0
onready var sprite=$Sprite
var numero="1"
signal objetoRoto()
func _ready():
	pass

func iniciar_Blink(numero):
	var play="Start"+numero
	$AnimationPlayer.play(play)

func _on_Timer_timeout():
	var play2="Stop"+numero
	$AnimationPlayer.play(play2)


func _on_Area2D_area_entered(area):
	if auxiliar<6:
		auxiliar+=1
		if auxiliar==3:
			$CollisionShape2D.set_deferred("disabled",true)
			$CollisionShape2D2.set_deferred("disabled",false)
			$Objeto_Rompible.position.x=16
			sprite.frame+=1
			sprite=$Sprite2
			numero="2"
		if auxiliar==6:
			emit_signal("objetoRoto")
			$CollisionShape2D2.set_deferred("disabled",true)
			$Objeto_Rompible/CollisionShape2D.set_deferred("disabled",true)
		sprite.frame+=1
		iniciar_Blink(numero)
		$Timer.start(0.3)
