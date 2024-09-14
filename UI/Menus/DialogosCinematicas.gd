extends RichTextLabel


export(Array) var dialog
var page=0
var dentro=false
signal finalice
func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	set_process_input(true)

func iniciar():
	$Timer.start()
	visible=true
	if get_visible_characters()>get_total_character_count():
		if page<dialog.size()-1:
			page+=1
			set_bbcode(dialog[page])
			set_visible_characters(0)
		else:
			page=-1
			set_bbcode(dialog[page])
			visible=false
			emit_signal("finalice")
	else:
		set_visible_characters(get_total_character_count())


func _on_Timer_timeout():
	if get_visible_characters()< get_total_character_count():
		$AudioStreamPlayer2D.play()
	set_visible_characters(get_visible_characters()+1)
