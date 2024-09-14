extends Camera2D

const LOOK_AHEAD_FACTOR=0.2
var facing=0
const SHIFT_TRANS=Tween.TRANS_SINE
const SHIFT_EASE=Tween.EASE_OUT
const SHIFT_DURATION=1.0
var saltando=false
var cayendo=false

onready var previousCamera=get_camera_position()
onready var tween=$ShiftTween
onready var player=get_parent()

func _process(delta):
#	if saltando:
#		self.offset.y=lerp(self.offset.y,-10,0.05)
	if cayendo:
		#self.offset.y=lerp(self.offset.y,10,0.05)
		if player.velocidad.y>90:
			position.y+=3
			position.y=min(50,position.y)
	if !cayendo and !saltando:
#		self.offset.y=lerp(self.offset.y,0,0.1)
		position.y=lerp(position.y,0,0.1)
	_check_facing()
	previousCamera=get_camera_position()

func _check_facing():
	#El round se ha puesto porque si no medio petaba en los bordes de los niveles
	var newFacing=sign(round(get_camera_position().x)-round(previousCamera.x))
	if newFacing !=0 && facing != newFacing && get_parent().direccion==newFacing:
		facing=newFacing
		var target_offset=get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		tween.interpolate_property(self,"position:x",position.x,target_offset,SHIFT_DURATION,SHIFT_TRANS,SHIFT_EASE)
		tween.start()

func _on_Jugador_en_aire(on_ground,falling):
	#drag_margin_v_enabled= !on_ground
	if !on_ground:
		if !falling:
			saltando=true
		else:
			saltando=false
			cayendo=true
	else:
		saltando=false
		cayendo=false
