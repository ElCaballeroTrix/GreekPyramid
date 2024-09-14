extends Control

var damage=1 setget set_damage
onready var damageUI=$Sword

func set_damage(value):
	damage=value
	if damageUI!=null:
		damageUI.rect_size.x=damage*7

func _ready():
	self.damage=PlayerStats.damage
	PlayerStats.connect("damage_changed",self,"set_damage")

