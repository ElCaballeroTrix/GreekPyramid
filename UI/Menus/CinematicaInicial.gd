extends Node

func _ready():
	$AnimationPlayer.playback_speed=0.75
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.stop_song()


func _on_DialogosCinematicas_finalice():
	get_tree().change_scene("res://Escenas/Nivel 1/Tutorial.tscn")
