extends Node

onready var tween=get_node("Tween")
signal cambioHabilidad()
var change_scene=null
var direccion=null
var nombre_audio_suelo="Piedra"
var nombre_carpeta_suelo="Piedra"
var FullScreen=false
var Resolucion=4
var Nivel_Sonido=0
var Nivel_Musica=0
var timerStart=0
var Sali_Menu=false
var Titulo_Reinicio=false
var reinicio=false
var Escena="res://UI/Menus/TitleScreen.tscn"
var checkpoint=false
var partidaActiva="???????????????"
var Guardado=[false,false,false]
var Guardado_Texto=["???????????????","???????????????","???????????????"]
var fecha0:Dictionary; var fecha1:Dictionary; var fecha2:Dictionary
var time0:int; var time1:int; var time2:int
var noHit=false
var Fecha={
	fecha0:fecha0,
	fecha1:fecha1,
	fecha2:fecha2
}
var TimePlayed={
	time0:0,
	time1:0,
	time2:0
}
var Controles={
	"attack":{"value":86,"key":true},
	"rodar":{"value":67,"key":true},
	"jump":{"value":32,"key":true},
	"ui_left":{"value":16777231,"key":true},
	"ui_right":{"value":16777233,"key":true},
	"mirar_arriba":{"value":16777232,"key":true},
	"mirar_abajo":{"value":16777234,"key":true},
	"habilidad":{"value":88,"key":true},
	"menu":{"value":16777217,"key":true}
}
var ControlesPorDefecto={
	"attack":86,
	"rodar":67,
	"jump":32,
	"ui_left":16777231,
	"ui_right":16777233,
	"mirar_arriba":16777232,
	"mirar_abajo":16777234,
	"habilidad":88,
	"menu":16777217
}
#Puede poner algo como por ejemplo, que si la saved file no contiene información sobre el gancho
#o futura habilidad, que borre el archivo
var monstruosVisibleMenu={
	gorgona = true,
	caribdis = true,
	serpopardo = true
}
var habilidadActivaMonstruo={
	gorgona = true,
	caribdis = false,
	serpopardo = false
}

var datos_partida={
	escena="res://Escenas/Nivel 1/Tutorial.tscn",
	monstruosVisibles=monstruosVisibleMenu,
	habilidadesActivas=habilidadActivaMonstruo,
	checkpoint=checkpoint,
	nCorazones=PlayerStats.max_health,
	noHit=noHit
}
var datos_configuracion={
	resolucion=4,
	fullScreen=false,
	nivel_Sonido=0,
	nivel_Musica=0,
	guardado=[false,false,false],
	guardado_texto=["???????????????","???????????????","???????????????"],
	fecha={fecha0:fecha0,fecha1:fecha1,fecha2:fecha2},
	timePlayed={time0:0,time1:0,time2:0},
	controles={"attack":86,"rodar":67,"jump":32,"ui_left":16777231,"ui_right":16777233,"mirar_arriba":16777232,"mirar_abajo":16777234,"habilidad":88,"menu":16777217}
}

func _ready():
	var ruta_guardado=Directory.new()
	if(!ruta_guardado.dir_exists("user://saves")):
		ruta_guardado.open("user://")
		ruta_guardado.make_dir("user://saves")
	ajustes()
	actualizar_ajustes()

func play_sound(sound):
	$Sonidos.stream=load(sound)
	$Sonidos.play()


func play_song(song):
	$Musica.stream=load(song)
	$Musica.play()

func facedOutSong(objetivo=-80,segundos=10.00):
	tween.interpolate_property($Musica,"volume_db",Nivel_Musica,objetivo,segundos,1,Tween.EASE_IN,0)
	tween.start()

func playerDeadSong():
	tween.interpolate_property($Musica,"volume_db",Nivel_Musica,-80,4.00,1,Tween.EASE_IN,0)
	tween.start()

func _on_Tween_tween_completed(object, key):
	#No queremos detener la canción en el caso de poca vida del jugador
	if $Musica.volume_db==-80:
		stop_song()
		$Musica.volume_db=Nivel_Musica

func stop_song():
	$Musica.stop()

func guardar_partida(nombre,primeraVez):
	var archivo_guardado=File.new()
	archivo_guardado.open("user://saves/"+nombre+".sav",File.WRITE)
	var datos=datos_partida
	if primeraVez:
		partidaActiva=nombre
		timerStart=0
	elif !primeraVez:
		datos.escena=get_tree().get_current_scene().get_filename()
	
	if nombre==Guardado_Texto[0]:
		Fecha.fecha0=OS.get_datetime()
		if timerStart!=0:
			TimePlayed.time0=TimePlayed.time0+(OS.get_unix_time()-timerStart)
		else: 
			timerStart=OS.get_unix_time()
			TimePlayed.time0=0
	elif nombre==Guardado_Texto[1]:
		Fecha.fecha1=OS.get_datetime()
		if timerStart!=0:
			TimePlayed.time1=TimePlayed.time1+(OS.get_unix_time()-timerStart)
		else: 
			timerStart=OS.get_unix_time()
			TimePlayed.time1=0
	elif nombre==Guardado_Texto[2]:
		Fecha.fecha2=OS.get_datetime() 
		if timerStart!=0:
			TimePlayed.time2=TimePlayed.time2+(OS.get_unix_time()-timerStart)
		else: 
			timerStart=OS.get_unix_time()
			TimePlayed.time2=0
	guardar_ajustes()
	
	datos.monstruosVisibles=monstruosVisibleMenu
	datos.habilidadesActivas=habilidadActivaMonstruo
	datos.checkpoint=checkpoint
	datos.nCorazones=PlayerStats.max_health
	datos.noHit=noHit
	datos.TimePlayed=TimePlayed
	#datos.TimePlayed=datos.TimePlayed+(OS.get_unix_time()-timerStart)
	archivo_guardado.store_line(to_json(datos))
	archivo_guardado.close()

func cargar_partida(nombre):
	var archivo_cargar=File.new()
	if(!archivo_cargar.file_exists("user://saves/"+nombre+".sav")):
		print("Noexistent save file")
		return
	archivo_cargar.open("user://saves/"+nombre+".sav",File.READ)
	var datos_load=datos_partida
	if(!archivo_cargar.eof_reached()):
		var datos_auxiliar=parse_json(archivo_cargar.get_line())
		if datos_auxiliar !=null:
			datos_load=datos_auxiliar
	archivo_cargar.close()
	if datos_load.escena=="res://Escenas/Nivel 1/Nivel_boss.tscn" && datos_load.checkpoint:
		Escena="res://Escenas/Nivel 1/2Parte_Nivel_1.tscn"
	elif datos_load.escena=="res://Escenas/Nivel 1/2Parte_Nivel_1.tscn" && !datos_load.checkpoint:
		Escena="res://Escenas/Nivel 1/Nivel_boss.tscn"
	else:
		Escena=datos_load.escena
	checkpoint=datos_load.checkpoint
	monstruosVisibleMenu=datos_load.monstruosVisibles
	habilidadActivaMonstruo=datos_load.habilidadesActivas
	PlayerStats.set_max_health(datos_load.nCorazones)
	PlayerStats.set_health(datos_load.nCorazones)
	noHit=datos_load.noHit
	partidaActiva=nombre
	#New
	TimePlayed=datos_load.TimePlayed
	#Inicializamos el tiempo de partida
	timerStart=OS.get_unix_time()

func eliminarPartida(nombreFichero):
	var directorioBorrar=Directory.new()
	var rutaFichero="user://saves/"+nombreFichero+".sav"
	directorioBorrar.remove(rutaFichero)

func guardar_ajustes():
	var archivo_configuracion=File.new()
	archivo_configuracion.open("user://saves/config.sav",File.WRITE)
	var config=datos_configuracion
	config.resolucion=Resolucion
	config.fullScreen=FullScreen
	config.nivel_Sonido=Nivel_Sonido
	config.nivel_Musica=Nivel_Musica
	config.guardado=Guardado
	config.guardado_texto=Guardado_Texto
	config.fecha=Fecha
	config.timePlayed=TimePlayed
	config.controles=Controles
#	config.fecha=fecha0
	archivo_configuracion.store_line(to_json(config))
	archivo_configuracion.close()

func ajustes():
	var archivo_config=File.new()
	if(!archivo_config.file_exists("user://saves/config.sav")):
		print("Noexistent settings file")
		return
	archivo_config.open("user://saves//config.sav",File.READ)
	var datos_ajustes=datos_partida
	if(!archivo_config.eof_reached()):
		var datos_auxiliar=parse_json(archivo_config.get_line())
		if datos_auxiliar !=null:
			datos_ajustes=datos_auxiliar
	archivo_config.close()
	Resolucion=datos_ajustes.resolucion
	FullScreen=datos_ajustes.fullScreen
	Nivel_Sonido=datos_ajustes.nivel_Sonido
	Nivel_Musica=datos_ajustes.nivel_Musica
	Guardado=datos_ajustes.guardado
	Guardado_Texto=datos_ajustes.guardado_texto
	Fecha=datos_ajustes.fecha
	TimePlayed=datos_ajustes.timePlayed
	Controles=datos_ajustes.controles
	establecerControles()
#	fecha0=datos_ajustes.day

func actualizar_ajustes():
	OS.window_fullscreen=FullScreen
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sonido"),Nivel_Sonido)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"),Nivel_Musica)
	if Global.Resolucion==0: OS.set_window_size(Vector2(640,480))
	if Global.Resolucion==1: OS.set_window_size(Vector2(720,480))
	if Global.Resolucion==2: OS.set_window_size(Vector2(720,576))
	if Global.Resolucion==3: OS.set_window_size(Vector2(800,600))
	if Global.Resolucion==4: OS.set_window_size(Vector2(1024,600))
	if Global.Resolucion==5: OS.set_window_size(Vector2(1152,864))
	if Global.Resolucion==6: OS.set_window_size(Vector2(1280,720))
	if Global.Resolucion==7: OS.set_window_size(Vector2(1280,800))
	if Global.Resolucion==8: OS.set_window_size(Vector2(1280,960))
	if Global.Resolucion==9: OS.set_window_size(Vector2(1280,1024))
	if Global.Resolucion==10: OS.set_window_size(Vector2(1360,768))
	if Global.Resolucion==11: OS.set_window_size(Vector2(1440,900))
	if Global.Resolucion==12: OS.set_window_size(Vector2(1600,900))
	if Global.Resolucion==13: OS.set_window_size(Vector2(1600,1200))
	if Global.Resolucion==14: OS.set_window_size(Vector2(1680,1050))
	if Global.Resolucion==15: OS.set_window_size(Vector2(1920,1080))

func cambiarHabilidad(habilidad):
	habilidadActivaMonstruo[habilidad]=!habilidadActivaMonstruo[habilidad]
	emit_signal("cambioHabilidad")

func establecerControles():
	var controlesNombres=["attack","rodar","jump","ui_left","ui_right","mirar_abajo","mirar_arriba","habilidad","menu"]
	for controlName in controlesNombres:
		var oldkey=InputEventKey.new()
		oldkey.scancode=int(ControlesPorDefecto[controlName])
		var newKey
		if Global.Controles[controlName].key:
			newKey=InputEventKey.new()
			newKey.scancode=int(Controles[controlName].value)
		else:
			newKey=InputEventMouseButton.new()
			newKey.button_index=int(Global.Controles[controlName].value)
		InputMap.action_erase_event(controlName,oldkey)
		InputMap.action_add_event(controlName,newKey)

func diedInNoHit():
	eliminarPartida(partidaActiva)
	if partidaActiva==Global.Guardado_Texto[0]:
		Global.Guardado[0]=false
		Global.Guardado_Texto[0]="???????????????"
		Global.Fecha.fecha0=null
		Global.TimePlayed.time0=0
		Global.guardar_ajustes()
#		guardados.desaparecerPartida(0)
	elif partidaActiva==Global.Guardado_Texto[1]:
		Global.Guardado[1]=false
		Global.Guardado_Texto[1]="???????????????"
		Global.Fecha.fecha1=null
		Global.TimePlayed.time1=0
		Global.guardar_ajustes()
#		guardados.desaparecerPartida(1)
	elif partidaActiva==Global.Guardado_Texto[2]:
		Global.Guardado[2]=false
		Global.Guardado_Texto[2]="???????????????"
		Global.Fecha.fecha2=null
		Global.TimePlayed.time2=0
		Global.guardar_ajustes()
#		guardados.desaparecerPartida(2)
	get_tree().change_scene("res://UI/Menus/TitleScreen.tscn")
