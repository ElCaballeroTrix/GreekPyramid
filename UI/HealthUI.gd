extends Control

var hearts=8 setget set_hearts
var max_hearts=8 setget set_max_hearts
var pocos_Corazones=false
onready var heartUIFull=$HeartUIFull
onready var heartUIEmpty=$HeartUIEmpty
onready var middleLine=$MiddleLine
onready var rightLine=$LineRightEnd
var cargasGancho = 3

func set_hearts(value):
	hearts=clamp(value,0,max_hearts)
	if heartUIFull!=null:
		#Se usa 9 ya que son los 8 bloques de largo del corazon más uno vacio
		#para que no esten juntos los corazones
		if int(hearts)%2==0:
			heartUIFull.rect_size.x=hearts*9/2
		else: heartUIFull.rect_size.x=(hearts-1)*9/2+4.5
	if hearts<=2:
		#Si el jugador solo tiene un corazón, los corazones vibran, pantalla roja, y latido
		pocos_Corazones=true
		heartUIEmpty.material.set_shader_param("onoff",0)
		heartUIFull.material.set_shader_param("onoff",0)
		$AnimationPlayer.play("Vibracion_Corazones")
		PlayerStats.poca_vida()
	else: 
		#Si estamos en fase de pocos corazones, el corazón no brilla
		pocos_Corazones=false
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Vibracion_Corazones")
		$AnimationPlayer.seek(0.0,true)
		$AnimationPlayer.stop()
		heartUIEmpty.material.set_shader_param("onoff",1)
		heartUIFull.material.set_shader_param("onoff",1)
		#Si recuperamos vida, después de estar a 1 de vida, paramos la animación del latido
#		$AnimationPlayer.stop()
#		if $AnimationPlayer.is_playing():
#			PlayerStats.recuperoVida()
#			$AnimationPlayer.get_animation("Vibracion_Corazones").loop=false
#			yield(get_node("AnimationPlayer"),"animation_finished")
#			$AnimationPlayer.stop()
#
#			$AnimationPlayer.get_animation("Vibracion_Corazones").loop=true


func set_max_hearts(value):
	max_hearts=max(value,1)
	self.hearts=min(hearts,max_hearts)
	if heartUIEmpty!=null:
		heartUIEmpty.rect_size.x=max_hearts*9/2
		middleLine.rect_size.x=max_hearts*9/2-18
		#rightLine.position.x=17+max_hearts*7
		rightLine.position.x=middleLine.rect_size.x+middleLine.rect_position.x

func _ready():
	$HeartUIFull.texture.pause=true
	$HeartUIFull.texture.current_frame=0
	self.max_hearts=PlayerStats.max_health
	self.hearts=PlayerStats.health
	if !Global.noHit:
		PlayerStats.connect("health_changed",self,"set_hearts")
		PlayerStats.connect("max_health_changed",self,"set_max_hearts")
	else:
		#Si estamos en modo NOHIT, solo sale un corazón
		heartUIFull.rect_size.x=(2-1)*9/2+4.5
		heartUIFull.rect_position.x+=4.5
		heartUIEmpty.rect_size.x=2*9/2
		heartUIEmpty.rect_position.x+=4.5
		middleLine.rect_size.x=1*9/2-18
		rightLine.position.x=middleLine.rect_size.x+middleLine.rect_position.x
	Global.connect("cambioHabilidad",self,"cambiarColorDeHabilidadActiva")
	if Global.monstruosVisibleMenu.gorgona:
		$Habilidades/HabilidadGorgona.visible=true
		if !Global.habilidadActivaMonstruo.gorgona:
			$Habilidades/HabilidadGorgona.modulate=Color("#df252525")
	if Global.monstruosVisibleMenu.caribdis :
		$Habilidades/HabilidadCaribdis.visible=true
		if !Global.habilidadActivaMonstruo.caribdis:
			$Habilidades/HabilidadCaribdis.modulate=Color("#df252525")
	if Global.monstruosVisibleMenu.serpopardo :
		$Habilidades/HabilidadSerpopardo.visible=true
		if !Global.habilidadActivaMonstruo.serpopardo:
			$Habilidades/HabilidadSerpopardo.modulate=Color("#df252525")

func cambiarColorDeHabilidadActiva():
	if !Global.habilidadActivaMonstruo["gorgona"]:
		$Habilidades/HabilidadGorgona.modulate=Color("#df252525")
	else: $Habilidades/HabilidadGorgona.modulate=Color("#ffffff")
	if !Global.habilidadActivaMonstruo["caribdis"]:
		$Habilidades/HabilidadCaribdis.modulate=Color("#df252525")
	else: $Habilidades/HabilidadCaribdis.modulate=Color("#ffffff")
	if !Global.habilidadActivaMonstruo["serpopardo"]:
		$Habilidades/HabilidadSerpopardo.modulate=Color("#df252525")
	else: $Habilidades/HabilidadSerpopardo.modulate=Color("#ffffff")


func _on_Timer_timeout():
	if !pocos_Corazones:
		$HeartUIFull.texture.oneshot=false
		$HeartUIFull.texture.pause=false
		pararAnimacion()


func pararAnimacion():
	yield(get_tree().create_timer(0.85),"timeout")
	$HeartUIFull.texture.current_frame=0
	$HeartUIFull.texture.oneshot=false
	$HeartUIFull.texture.pause=true

