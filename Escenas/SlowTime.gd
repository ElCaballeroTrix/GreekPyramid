extends Node


const END_VALUE = 1
var is_active = false
var time_start
var duration
var startValue #Para la función

func startSlowMotion(durationSeconds = 0.4, strength = 0.5):
	time_start = OS.get_ticks_msec()
	self.duration = durationSeconds * 1000
	startValue = 1 - strength
	Engine.time_scale = startValue
	is_active = true

func _process(delta):
	if is_active:
		var current_time = OS.get_ticks_msec() - time_start
		var value = circl_ease_in(current_time, startValue, END_VALUE, duration)
		if current_time >= duration:
			is_active = false
			value = END_VALUE
		Engine.time_scale = value

func circl_ease_in(currentTime, startValue, endValue, duration):
	currentTime /= duration
	return -endValue * (sqrt(1 - currentTime * currentTime) - 1) + startValue

