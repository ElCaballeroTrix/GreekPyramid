extends StaticBody2D

export var hitboxUp = false
export var hitboxLeft = false
export var hitboxRight = false
export var hitboxDown = false

func _ready():
	if hitboxUp: $HitboxUp/CollisionShape2D.set_deferred("disabled", false)
	else: $HitboxUp/CollisionShape2D.set_deferred("disabled", true)
	if hitboxDown: $HitboxDown/CollisionShape2D.set_deferred("disabled", false)
	else: $HitboxDown/CollisionShape2D.set_deferred("disabled", true)
	if hitboxLeft: $HitboxLeft/CollisionShape2D.set_deferred("disabled", false)
	else: $HitboxLeft/CollisionShape2D.set_deferred("disabled", true)
	if hitboxRight: $HitboxRight/CollisionShape2D.set_deferred("disabled", false)
	else: $HitboxRight/CollisionShape2D.set_deferred("disabled", true)
