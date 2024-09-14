extends Node2D


export var spriteAnim="PajaroBlancoLado"
export var vectorDireccion=Vector2(-5,0)
export var spriteFlip=true
func _ready():
	$AnimatedSprite.animation=spriteAnim
	$AnimatedSprite.flip_h=spriteFlip

func _process(delta):
	position+=vectorDireccion
