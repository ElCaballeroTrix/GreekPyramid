extends CanvasLayer


func _ready():
	#Cambiar a mobile en vez de editor
	if OS.has_feature("mobile"):
		$MobileButtons.visible=true
		$MobileButtons/Ability.visible=false
		habilidadVisible()
	Global.connect("cambioHabilidad",self,"habilidadVisible")

func habilidadVisible():
	if Global.habilidadActivaMonstruo.gorgona:
		$MobileButtons/Ability.visible=true
		$MobileButtons/Ability.normal=load("res://UI/MobileControls/GorgonaMobile.png")
		$MobileButtons/Ability.pressed=load("res://UI/MobileControls/GorgonaMobilePressed.png")
	if Global.habilidadActivaMonstruo.caribdis:
		$MobileButtons/Ability.visible=true
		$MobileButtons/Ability.normal=load("res://UI/MobileControls/CaribdisMobile.png")
		$MobileButtons/Ability.pressed=load("res://UI/MobileControls/CaribdisMobilePressed.png")


