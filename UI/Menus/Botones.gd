extends ParallaxLayer

onready var Jugar=$Menu_Principal/Jugar
onready var Opciones=$Menu_Principal/Opciones
onready var Salir=$Menu_Principal/Salir
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if Jugar.is_hovered()==true:
		Jugar.grab_focus()
	if Opciones.is_hovered()==true:
		Opciones.grab_focus()
	if Salir.is_hovered()==true:
		Salir.grab_focus()


func _on_Jugar_pressed():
	#Global.cargar_partida("Trix")
	var Escena_Opcion=load("res://UI/Menus/Guardados.tscn")
	var Escena=Escena_Opcion.instance()
	Escena.connect("cierreMenu",self,"apuntaABotonJugar")
	add_child(Escena)


func _on_Opciones_pressed():
	var Escena_Opcion=load("res://UI/Menus/OptionMenu.tscn")
	var Escena=Escena_Opcion.instance()
	Escena.connect("cierreMenu",self,"apuntaABotonOpciones")
	add_child(Escena)

func apuntaABotonOpciones():
	Opciones.grab_focus()

func apuntaABotonJugar():
	Jugar.grab_focus()

func _on_Salir_pressed():
	get_tree().quit()
