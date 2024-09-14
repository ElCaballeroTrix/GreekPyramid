extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation="default"

func _process(delta):
	$AnimatedSprite.rotation+=0.03

func _on_Hurtbox_area_entered(area):
	#apply_central_impulse(Vector2(200,-30))
	if area.global_position.x> global_position.x:
		apply_impulse(Vector2(0,0),Vector2(-100,-30).rotated(rotation))
	else:
		apply_impulse(Vector2(0,0),Vector2(100,-30).rotated(rotation))
	$HitboxBoulder.set_collision_mask_bit(3,true)

func _on_ObjetoCaeEmpujable_body_entered(body):
	if body.name=="TileMap" || body.get_parent().name=="ArenasMovidizas" || body.name=="TileMapSegundaFase":
		desaperece()

func desaperece():
	$AudioStreamPlayer2D.play()
	set_deferred("mode",RigidBody2D.MODE_STATIC)
	$Particles2D.emitting=false
	$CollisionShape2D.set_deferred("disabled",true)
	$HitboxBoulder/CollisionShape2D.set_deferred("disabled",true)
	$Objeto_Rompible/CollisionShape2D.set_deferred("disabled",true)
	$AnimatedSprite.animation="Desaparece"
	yield($AnimatedSprite,"animation_finished")
	queue_free()
