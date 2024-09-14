extends Node

export(int) var max_health=1 setget set_max_health
var health=max_health setget set_health
export(int) var damage=1 setget set_damage
var cambio=false
var bajarMusicaActivo=false

signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal damage_changed(value)

func set_damage(value):
	damage=value
	emit_signal("damage_changed",damage)

func set_max_health(value):
	max_health=value
	self.health=min(health,max_health)
	emit_signal("max_health_changed",max_health)

func set_health(value):
	health=value
	emit_signal("health_changed",health)
	if health<=0:
		emit_signal("no_health")

func increase_health():
	if health<max_health:
		health+=2
		emit_signal("health_changed",health)
		cambio=true
		if health==3 or health==4:
			recuperoVida()

func _ready():
	self.health=max_health

func poca_vida():
	if health<=0:
		$AnimationDolor.stop()
		$CanvasLayer/ColorRect.color="00ec0a0a"
	else:
		if !bajarMusicaActivo:
			#Sirve para que solo baje la música una vez, cuando pase
			#de 4 corazones a 2, o 3 a 1, por ejemplo
			Global.facedOutSong(Global.Nivel_Musica-5,5.00)
			bajarMusicaActivo=true
		$AnimationDolor.play("Latido")

func recuperoVida():
	bajarMusicaActivo=false
	Global.facedOutSong(Global.Nivel_Musica+5,5.00)
	$AnimationDolor.get_animation("Latido").loop=false
	yield(get_node("AnimationDolor"),"animation_finished")
	$AnimationDolor.stop()
	$AnimationDolor.get_animation("Latido").loop=true

func damage_changed(value):
	#Funcion por si quiero cambiar el daño del jugador
	pass
