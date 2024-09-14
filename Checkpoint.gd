extends Area2D

export (int) var frame
func _ready():
	if Global.checkpoint:
		$Sprite.frame=frame


func _on_Checkpoint_body_entered(body):
	if body.name=="Jugador" && !Global.checkpoint:
		Global.checkpoint=true
		$AudioStreamPlayer2D.play()
		$Particles2D.emitting=true
		$Sprite.frame=frame
