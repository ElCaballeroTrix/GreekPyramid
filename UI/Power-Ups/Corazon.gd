extends Area2D


func _ready():
	if Global.noHit:
		visible=false
		$CollisionShape2D.set_deferred("disabled",true)

func _on_Corazon_body_entered(body):
	if body.name=="Jugador":
		PlayerStats.increase_health()
		if PlayerStats.cambio:
			$AudioStreamPlayer.play()
			visible=false
			$CollisionShape2D.set_deferred("disabled",true)
			yield(get_node("AudioStreamPlayer"),"finished")
			PlayerStats.cambio=false
			queue_free()


func _on_Objeto_Rompible_objetoRoto():
	if !Global.noHit:
		visible=true

func _on_Objeto_Rompible3_objetoRoto():
	if !Global.noHit:
		visible=true
