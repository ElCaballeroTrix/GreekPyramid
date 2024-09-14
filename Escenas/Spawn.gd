extends Position2D

export(PackedScene) var npc
export (Vector2) var direccion
export (String) var sprite
export (String) var sonido
export (int) var speed
func _ready():
	pass 


func _on_Timer_timeout():
	var newEnemigo=npc.instance()
	newEnemigo.direccion=direccion
	newEnemigo.sprite=sprite
	newEnemigo.sonido=sonido
	newEnemigo.speed=speed
	add_child(newEnemigo)
	newEnemigo.global_position=global_position

