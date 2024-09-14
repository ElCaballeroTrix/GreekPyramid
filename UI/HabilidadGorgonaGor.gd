extends TextureRect


onready var time_label = $Label
export var textura="res://Jefes/Gorgona/CabezaGorgonaProgress.png"
export var cooldown = 30


func _ready():
	$Timer.wait_time = cooldown
	time_label.hide()
	$TextureProgress.texture_progress = load(textura)
	$TextureProgress.value = 0
	set_process(false)

func _process(delta):
	time_label.text = "%d" % $Timer.time_left
	$TextureProgress.value = int(($Timer.time_left / cooldown) * 100)

func inicioCooldown():
	set_process(true)
	$Timer.start()
	time_label.show()

func _on_Timer_timeout(): 
	$TextureProgress.value = 0
	time_label.hide()
	set_process(false)
