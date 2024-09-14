extends TextureButton

export (String)var action=""
var ableToChange=false
signal cambioAcabado(boton)
func _ready():
	$Key.visible=false
	$Key.rect_position.x=1
	$Button.modulate=Color("#0015dc50")
	var text
	if Global.Controles[action].key:
		text=OS.get_scancode_string(Global.Controles[action].value)
		if text.length()>1:
			$Label.get_font("font").size=10
		else: 
			$Label.get_font("font").size=32
	else:
		text=Global.Controles[action].value
		$Label.get_font("font").size=10
		showMouseButton(str(text))
	$Label.rect_size=Vector2(37,37)
	$Label.text=str(text)


func _on_Key_gui_input(event):
	if ((event is InputEventKey and event.scancode!=16777221 and event.scancode!=16777222) or event is InputEventMouseButton) and ableToChange :
		emit_signal("cambioAcabado",$Button)
		$AudioControl.play()
		$AnimationPlayer.stop()
		rect_scale=Vector2(1,1)
		$Key.visible=false
		ableToChange=false
		$Key.editable=false
		$Key.release_focus()
		$Key.text=""
		$Button.visible=true
		if event is InputEventKey:
			var text=OS.get_scancode_string(event.scancode)
			if text.length()>1:
				$Label.get_font("font").size=10
			else: $Label.get_font("font").size=32
			$Label.rect_size=Vector2(37,37)
			$Label.text=text
			#Global
			var oldkey=InputEventKey.new()
			oldkey.scancode=int(Global.Controles[action].value)
			InputMap.action_erase_event(action,oldkey)
			InputMap.action_add_event(action,event)
			Global.Controles[action]={"value":event.scancode,"key":true}
			$Sprite.visible=false
		else:
			var text=str(event.button_index)
			$Label.get_font("font").size=10
			$Label.rect_size=Vector2(37,37)
			$Label.text=text
			showMouseButton(text)
			#Global
			var oldkey
			if Global.Controles[action].key:
				oldkey=InputEventKey.new()
				oldkey.scancode=int(Global.Controles[action].value)
			else:
				oldkey=InputEventMouseButton.new()
				oldkey.button_index=int(Global.Controles[action].value)
			InputMap.action_erase_event(action,oldkey)
			InputMap.action_add_event(action,event)
			Global.Controles[action]={"value":event.button_index,"key":false}
		Global.guardar_ajustes()

func _on_Button_pressed():
	$Sprite.visible=false
	$Key.visible=true
	$Key.grab_focus()
	$Key.editable=true
	ableToChange=true
	$Button.visible=false
	$Label.text=""
	$AnimationPlayer.play("ParpadeoControlButton")


func _on_Button_focus_entered():
	$Button.modulate=Color("#a715dc50")


func _on_Button_focus_exited():
	$Button.modulate=Color("#0015dc50")


func _on_Button_mouse_entered():
	$Button.modulate=Color("#a715dc50")


func _on_Button_mouse_exited():
	$Button.modulate=Color("#0015dc50")


func showMouseButton(mouseButton):
	match mouseButton:
		"1": $Sprite.frame=0
		"2": $Sprite.frame=1
		"3": $Sprite.frame=2
	$Sprite.visible=true
