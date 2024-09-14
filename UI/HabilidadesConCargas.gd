extends TextureRect


onready var charge_label = $CargasGancho
export var textura="res://Jefes/Serpopardo/CabezaSerpopardoMenu.png"
export var cooldown = 30
export var cargasTotales = 3
var cargas


func _ready():
	$TimerOfCharges.wait_time = cooldown
	cargas = cargasTotales
	charge_label.hide()
	$TextureProgress.texture_progress = load(textura)
	$TextureProgress.value = 0
	set_process(false)

func _process(delta):
	$TextureProgress.value = int(($TimerOfCharges.time_left / cooldown) * 100)

func inicioCooldown():
	if cargas == cargasTotales: #Si es la primera que se ejecuta la habilidad
		set_process(true)
		$TimerOfCharges.start()
		charge_label.show()

func _on_TimerOfCharges_timeout():
	recargar()
	$TextureProgress.value = 0
	set_process(false)
	if cargas < cargasTotales:
		set_process(true)
		$TimerOfCharges.start()

func recargar():
	cargas += 1
	charge_label.text = str(cargas)
	#Sonidito de recarga

func eliminarCargaGancho():
	cargas -=1
	charge_label.text = str(cargas)
