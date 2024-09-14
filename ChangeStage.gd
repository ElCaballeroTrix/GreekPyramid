extends Area2D

export(String, FILE, "*.tscn") var target_stage

func _physics_process(delta):
	var bodies=get_overlapping_bodies()
	for body in bodies:
		if body.name=="Jugador":
			get_tree().change_scene(target_stage)
			Global.change_scene=name






