extends Node2D

signal modeDecided()
func _ready():
	$MarginContainer/VBoxContainer/YesNormalMode.grab_focus()
	$AnimationPlayer.play("YesNormalMode")

func _on_YesNormalMode_pressed():
	emit_signal("modeDecided")
	queue_free()


func _on_YesNoHit_pressed():
	Global.noHit=true
	emit_signal("modeDecided")
	queue_free()


func _on_YesNormalMode_focus_entered():
	$AudioStreamPlayer.play()
	$MarginContainer/VBoxContainer/YesNoHit.rect_position=Vector2(190,207)
	$MarginContainer/VBoxContainer/YesNoHit.rect_scale=Vector2(1,1)
	$AnimationPlayer.play("YesNormalMode")


func _on_YesNormalMode_mouse_entered():
	$AudioStreamPlayer.play()
	$MarginContainer/VBoxContainer/YesNoHit.rect_position=Vector2(190,207)
	$MarginContainer/VBoxContainer/YesNoHit.rect_scale=Vector2(1,1)
	$AnimationPlayer.play("YesNormalMode")


func _on_YesNoHit_focus_entered():
	$AudioStreamPlayer.play()
	$MarginContainer/VBoxContainer/YesNormalMode.rect_position=Vector2(190,93)
	$MarginContainer/VBoxContainer/YesNormalMode.rect_scale=Vector2(1,1)
	$AnimationPlayer.play("YesNoHitMode")


func _on_YesNoHit_mouse_entered():
	$MarginContainer/VBoxContainer/YesNoHit.grab_focus()
	$AudioStreamPlayer.play()
	$MarginContainer/VBoxContainer/YesNormalMode.rect_position=Vector2(190,93)
	$MarginContainer/VBoxContainer/YesNormalMode.rect_scale=Vector2(1,1)
	$AnimationPlayer.play("YesNoHitMode")
