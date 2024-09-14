extends RichTextLabel


export(Array) var dialog
var page=0
var dentro=false
onready var JugadorAnimacion=get_parent().get_parent().get_node("../Jugador/AnimationPlayer")
onready var Jugador=get_parent().get_parent().get_node("../Jugador")
signal finalice
export var root="Tutorial"
onready var zonaDeDialogo=get_tree().get_root().get_node(root)
signal controlesVisibles(visibilidad)
signal pageNumber(number)
func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	set_process_input(true)
	zonaDeDialogo.connect("body_entered",self,"jugadorEntra")
	zonaDeDialogo.connect("body_exited",self,"jugadorSeVa")

func _input(event):
	if (Input.is_action_pressed("ui_accept") or (event is InputEventScreenTouch and event.is_pressed())) and dentro==true:
		$Timer.start()
		JugadorAnimacion.play("Idle")
		Jugador.set_physics_process(false)
		visible=true
		if OS.has_feature("mobile"):
			emit_signal("controlesVisibles",false)
		if get_visible_characters()>get_total_character_count():
			if page<dialog.size()-1:
				page+=1
				emit_signal("pageNumber",page)
				set_bbcode(dialog[page])
				set_visible_characters(0)
			else:
				page=-1
				set_bbcode(dialog[page])
				visible=false
				Jugador.state=0
				emit_signal("finalice")
				if OS.has_feature("mobile"):
					emit_signal("controlesVisibles",true)
				yield(get_tree().create_timer(0.4),"timeout")
				Jugador.set_physics_process(true)
		else:
			set_visible_characters(get_total_character_count())

func dialogStart():
	if OS.has_feature("mobile"):
		emit_signal("controlesVisibles",false)
	$Timer.start()
	visible=true

func _on_Timer_timeout():
	if get_visible_characters()< get_total_character_count():
		$AudioStreamPlayer2D.play()
	set_visible_characters(get_visible_characters()+1)

func jugadorEntra(body):
	if body.name=="Jugador":
		dentro=true

func jugadorSeVa(body):
	if body.name=="Jugador":
		dentro=false
