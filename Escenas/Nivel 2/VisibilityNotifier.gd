extends Node2D


# Mejora los FPS, muestra un trozo de la escena solo cuando este en pantall

onready var visibility_notifier:= $VisibilityNotifier2D
func _ready():
	visibility_notifier.connect("screen_entered",self,"show")
	visibility_notifier.connect("screen_exited",self,"hide")
	visible=false
