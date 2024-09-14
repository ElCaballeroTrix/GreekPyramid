extends KinematicBody2D

export var speed=200
export var salto=100 #250 esta nice(creo), pero creo que F y deberia ser 270 o 280
export var gravedad=550
export var roll_speed=175
export var inercia=50
var direccion=0
var distancia=Vector2()
var velocidad=Vector2()
var stats=PlayerStats
onready var vida=stats.max_health
onready var animacion=$AnimationPlayer
onready var sprite=$Sprite
var interferencia=Vector2.ZERO #Se usa para el knockback
var Hit
onready var Hurt=$Hurtbox/CollisionShape2D
onready var Hurt_Rodar=$Hurt_rodar/CollisionShape2D
onready var polvo=preload("res://Tileset/Decoraciones/Polvo/Polvo_Escena.tscn")
onready var healthUI = $CanvasLayer/HealthUI
onready var habilidadVisibleGorgona=$CanvasLayer/HealthUI/Habilidades/HabilidadGorgona
onready var habilidadVisibleCaribdis=$CanvasLayer/HealthUI/Habilidades/HabilidadCaribdis
onready var habilidadVisibleSerpopardo=$CanvasLayer/HealthUI/Habilidades/HabilidadSerpopardo
onready var posicionProyectiles=$PosicionProyectiles
onready var flechaApuntar = $FlechaApuntar
onready var nodoPadre=get_parent().get_node(".")
var attack=0
var on_ground=false
var attack_der=true
var attack_in_air=false
var roll=0
var rodar_golpe=0
var mirandoFrente=false
var saltando=false
var minimo_salto=false
var limite=Vector2.ZERO
var knockback=Vector2.ZERO
var finish_knockback=true
var friction=200
var luchando_con_boss=false
var luchando_con_boss_empuje=Vector2.ZERO
var direccion_vuelo_empuje
var mirandoAbajo=false
var inputBuffer: Array=[]
var empujandoObjeto=false
var cuerpoStuneadoGorgona
const GANCHO_PULL = 30
var velocidadGancho := Vector2.ZERO
var ganchoAbilitado = false
signal en_aire(on_ground,falling)
signal luchando_con_boss(valorx,valory,direccion_vuelo)
signal fin_de_empuje_boss()
signal teletransporte_muerto()
signal comienzaStunGorgona()
signal acabaStunGorgona()
signal muriendo()
enum {
	MOVE,
	ROLL,
	ATTACK_Derecha,
	ATTACK_Izquierda,
	ATTACK_Arriba,
	ATTACK_Abajo,
	LOOK_DOWN,
	DANO,
	DEAD,
	BRINCO,
	STUN_GORGONA,
	OLA_CARIBDIS,
	GANCHO_SERPOPARDO,
	APUNTANDO
}
var state=MOVE

func _ready():
	randomize() 
	animacion.play("Idle")
	stats.connect("no_health",self,"dead") #Si te quedas sin vida, señal de muerte
	set_physics_process(true)              
	$Hit_Arriba.knockback_vector=Vector2.LEFT    #Inicializamos los knockback
	$Hit_Derecha.knockback_vector=Vector2.LEFT
	$Hit_Izquierda.knockback_vector=Vector2.LEFT
	#$Hit_Abajo.knockback_vector=Vector2.LEFT  ¿Influye al empuar enemigos que esten debajo?

#physics_process es como process pero te sirve para saber la localización del personaje y otras cositas
func _physics_process(delta):
		#if velocidad.y<-160 and velocidad.y>-170 and minimo_salto==true:
		#	velocidad.y=-80 
		knockback=knockback.move_toward(Vector2.ZERO,friction*delta)
		knockback=move_and_slide(knockback)
		if on_ground==true: 
			knockback.y=0           #No hay knockback hacia arriba en suelo
			attack_in_air=false     #Para que no pueda atacar dos veces en el aire  
		if Input.is_action_just_released("mirar_abajo") and on_ground==true and mirandoAbajo:
			$Tiempo_mirando_abajo.stop()
			$Camera2D.position.y=0
			mirandoAbajo=false
			state=MOVE
		#Esto es para cuando estaba mirando de frente y realizo un movimiento
		if animacion.current_animation!="Frente" && animacion.current_animation!="Idle":
			mirandoFrente=false
		match state:
			MOVE:
				move(delta)
				#Si se queda atascado en unos pinchos por arriba
				#automaticamente rueda el personaje
				if !stuck() && !empujandoObjeto:
					state=ROLL
			ROLL:
				roll_state(delta)
			LOOK_DOWN:
				mirar_abajo()
			ATTACK_Derecha: #Sirve para continuar con el movimiento en el aire mientras atacas
				if on_ground==false && !$RayCastCercaDelSueloAtaque.is_colliding():   
					distancia.x=speed*delta
					velocidad.x=(distancia.x*direccion)/delta
					velocidad.y += gravedad*delta
					velocidad=move_and_slide(velocidad,Vector2(0,-1))
				attack_state_der()
			ATTACK_Izquierda:
				if on_ground==false && !$RayCastCercaDelSueloAtaque.is_colliding():
					distancia.x=speed*delta
					velocidad.x=(distancia.x*direccion)/delta
					velocidad.y += gravedad*delta
					velocidad=move_and_slide(velocidad,Vector2(0,-1))
				attack_state_izq()
			ATTACK_Arriba:
				if on_ground==false:
					distancia.x=speed*delta
					velocidad.x=(distancia.x*direccion)/delta
					velocidad.y += gravedad*delta
					velocidad=move_and_slide(velocidad,Vector2(0,-1))
				attack_state_arr()
			ATTACK_Abajo:
				if on_ground==false and finish_knockback==true:
					distancia.x=speed*delta
					velocidad.x=(distancia.x*direccion)/delta
					velocidad.y += gravedad*delta
					velocidad=move_and_slide(velocidad,Vector2(0,-1))
					attack_state_aba()
				elif on_ground==false: attack_state_aba()
				else: state=MOVE
			BRINCO:
					velocidad.y += gravedad*delta
					if luchando_con_boss==true:      #Este estado permite un empuje sin recibir daño, como el agua de Caribdis
						knockback.x=direccion_vuelo_empuje*luchando_con_boss_empuje.x
						knockback.y+=gravedad*delta*luchando_con_boss_empuje.y
						knockback=move_and_slide(knockback,Vector2.UP)
						brinco()
			DANO:
				velocidad.y += gravedad*delta    #Si mueres en el aire, caes
				if luchando_con_boss==true:      #Es el knockback del jefe al jugador
					knockback.x=direccion_vuelo_empuje*luchando_con_boss_empuje.x
					knockback.y+=gravedad*delta*luchando_con_boss_empuje.y
				else:                            #Empuje hacia atras contra criatura
					knockback.x=sign(interferencia.x)*(speed/3)
					knockback.y+=gravedad*delta
				knockback=move_and_slide(knockback,Vector2.UP)
				dano()
			DEAD:
				muerto(delta)
			APUNTANDO:
				apuntando(delta)
			STUN_GORGONA:
				stun_gorgona()
			OLA_CARIBDIS:
				ola_caribdis()
			GANCHO_SERPOPARDO:
				fisicas_gancho(delta)

func move(delta): #Estado de movimiento
	direccion= int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	roll=direccion
	if direccion<0: #Mirando hacia la izquierda
		Global.direccion=-1
		attack_der=false
		sprite.flip_h=true
		animacion.play("Correr")
		$Hit_Izquierda.knockback_vector.x=direccion
		$Hit_Izquierda.knockback_vector.y=0
	elif direccion>0: #Mirando hacia la derecha
		Global.direccion=1
		attack_der=true
		sprite.flip_h=false
		animacion.play("Correr")
		$Hit_Derecha.knockback_vector.x=direccion
		$Hit_Derecha.knockback_vector.y=0
	else:             #Esta quieto
		if on_ground==true:
			$AudioStreamPlayer.stop()
			if mirandoFrente:
				animacion.play("Frente")
			else:
				animacion.play("Idle")
	#Movimiento
	distancia.x=speed*delta
	velocidad.x=lerp(velocidad.x,(distancia.x*direccion)/delta,get_weight()) #Creo que es una interpolación
	velocidad.y += gravedad*delta
	velocidad.y=min(250, velocidad.y)
	corner_correction(5)
	velocidad=move_and_slide(velocidad,Vector2(0,-1),false,4,PI/4,false)
	if !is_on_floor() && on_ground && !saltando: #Coyote time
		$Coyote_Timer.start()
		velocidad.y=0
	if is_on_floor() && !$JumpBuffer.is_stopped(): #Jump buffer
		$JumpBuffer.stop()
	for index in get_slide_count(): #Con esto, podemos mover objetos
		var cuerpo_colision=get_slide_collision(index)
		if cuerpo_colision.collider.is_in_group("cuerpos_moviles"):
			cuerpo_colision.collider.apply_central_impulse(-cuerpo_colision.normal * inercia)
	if is_on_floor():
		on_ground=true
		$Timer_Ataque.stop()
		emit_signal("en_aire",on_ground,false)
	else:
		on_ground=false
		saltando=false
		emit_signal("en_aire",on_ground,false)
		if velocidad.y<0:
			animacion.play("Salto")
		elif $Coyote_Timer.is_stopped():
			minimo_salto=false
			emit_signal("en_aire",on_ground,true)
			animacion.play("Caida")
	if Input.is_action_just_pressed("rodar") and is_on_floor():
		state=ROLL
		
	if Input.is_action_just_pressed("jump"):
		#Input Buffer
		inputBuffer.push_back(KEY_SPACE)
		var timerInputBuffer=Timer.new()
		timerInputBuffer.connect("timeout",self,"quitarAccionInputBuffer")
		add_child(timerInputBuffer) 
		timerInputBuffer.start(0.5)
		
	if (on_ground==true || !$Coyote_Timer.is_stopped()) && state!=ROLL:
		if inputBuffer.size()>0 && inputBuffer.front()==KEY_SPACE:
			$Coyote_Timer.stop()
			salto()
			inputBuffer.pop_front()
	else: $JumpBuffer.start()
	if Input.is_action_just_released("jump") and on_ground==false and velocidad.y < -salto*0.5:
		velocidad.y=-salto*0.5   
		minimo_salto=true
	if Input.is_action_just_pressed("mirar_abajo") and animacion.current_animation=="Idle"  and on_ground==true:
		mirandoAbajo=true
		$Tiempo_mirando_abajo.start()
	
	if Input.is_action_pressed("attack") && $Timer_Ataque.time_left==0:
		if Input.is_action_pressed("mirar_arriba"):
			$Hit_Arriba.knockback_vector=Vector2.UP
			state=ATTACK_Arriba
		elif Input.is_action_pressed("mirar_abajo"):
			var random_r_l=["RIGHT","LEFT"] #Sirve para que el knockback de arriba hacia abajo vaya o derecha o izquierda
			var random_atk_abajo=random_r_l[randi() % random_r_l.size()]
			if random_atk_abajo=="RIGHT":
				$Hit_Abajo.knockback_vector=Vector2.RIGHT * Vector2.DOWN
			else:
				$Hit_Abajo.knockback_vector=Vector2.LEFT * Vector2.DOWN
			state=ATTACK_Abajo
		elif attack_der==true:
			$Hit_Derecha.knockback_vector=Vector2.RIGHT #Para que no sea todo el rato la misma animación
			if attack==0: attack=1
			elif attack==1: attack=2
			elif attack==2: attack=3
			else: attack=1
			state=ATTACK_Derecha
		elif attack_der==false:
			$Hit_Izquierda.knockback_vector=Vector2.LEFT #Para que no sea todo el rato la misma animación
			if attack==0: attack=1
			elif attack==1: attack=2
			elif attack==2: attack=3
			else: attack=1
			state=ATTACK_Izquierda
	
#	if Input.is_action_just_pressed("habilidad") and on_ground==false and Global.monstruosVisibleMenu.gorgona:
#		noSePuedeUsarHabilidad()
	if Input.is_action_just_pressed("habilidad") and Global.monstruosVisibleMenu.gorgona:
		if Global.habilidadActivaMonstruo["gorgona"]:
			if on_ground:
				if $CanvasLayer/HealthUI/Habilidades/HabilidadGorgona/Timer.time_left==0:
					state=STUN_GORGONA
				else: noSePuedeUsarHabilidad()
			else: noSePuedeUsarHabilidad()
		if Global.habilidadActivaMonstruo["caribdis"]:
			if on_ground:
				if $CanvasLayer/HealthUI/Habilidades/HabilidadCaribdis/Timer.time_left==0:
					state=OLA_CARIBDIS
				elif Global.habilidadActivaMonstruo.caribdis: noSePuedeUsarHabilidad()
			else: noSePuedeUsarHabilidad()
		if Global.habilidadActivaMonstruo["serpopardo"]:
			if $CanvasLayer/HealthUI/Habilidades/HabilidadSerpopardo.cargas > 0:
				#Activamos el apuntado si no estamos apuntando, si estamos apuntando lanzamos el gancho
				if sprite.flip_h: #Mirando hacia la izquierda
					animacion.play("ApuntarIzquierda")
				if !sprite.flip_h: #Mirando hacia la derecha
					animacion.play("ApuntarDerecha")
				$SlowTime.startSlowMotion(2,0.5)
				state = APUNTANDO
			else: noSePuedeUsarHabilidad()

func noSePuedeUsarHabilidad():
	$AudioStreamPlayer2.stream=load("res://Sonidos/Menu/Nope.wav")
	$AudioStreamPlayer2.play()

func get_weight():
	return 0.2 if on_ground else 0.1

func mirarDeFrente():
	mirandoFrente=true

func salto():
	saltando=true
	$AudioStreamPlayer.stream=load("res://Sonidos/Salto/Salto1.wav")
	$AudioStreamPlayer.play()
	var polvo_escena=polvo.instance()   #Creamos el polvo, más juicy salto
	polvo_escena.emitting=true
	polvo_escena.global_position=Vector2(global_position.x,global_position.y+20) #+20 para que salga un poquito debajo
	get_parent().add_child(polvo_escena)
	velocidad.y=-salto
	on_ground=false

func corner_correction(amount: int):
	var delta=get_physics_process_delta_time()
	if velocidad.y<0 and test_move(global_transform, Vector2(0,velocidad.y*delta)):
		for i in range(1,amount+1):
			for j in [-1.0,1.0]:
				if !test_move(global_transform.translated(Vector2(i*j/2,0)), Vector2(0,velocidad.y*delta)):
					translate(Vector2(i*j/2,0))
					if velocidad.x *j<0: velocidad.x=0
					return

func roll_state(delta):
	knockback.y=0
	Hurt.set_deferred("disabled",true)         #Hurtbox de pie desactivado
	Hurt_Rodar.set_deferred("disabled",false)  #Hurtbox rodando activado
	if roll==0:
		if sprite.flip_h==true: roll=-1
		else: roll=1
	velocidad.x=roll*roll_speed
	velocidad.y+= gravedad*delta
	$Colision.disabled=true         #Colisión de pie
	$ColisionRodar.disabled=false   #Colisión rodando
	animacion.play("Rodar")
	move_and_slide(velocidad,Vector2(0,-1),false,4,PI/4,false)  #Se aplica para hacer el movimiento más rápido
	if is_on_floor():
		var polvo_escena=polvo.instance()    #Partículas de polvo
		polvo_escena.emitting=true
		polvo_escena.global_position=Vector2(global_position.x,global_position.y+20)
		get_parent().add_child(polvo_escena)


func attack_state_der():  #Se activa la hitbox de la derecha y su animación
	Hit=$Hit_Derecha/CollisionShape2D
	animacion.playback_speed=1.5
	#Hit.set_deferred("disabled",false)
	if on_ground==true:
		if attack==1:
			animacion.play("Ataque_Derecha")
		elif attack==2:
			animacion.play("Ataque_Derecha2")
		else:
			animacion.play("Ataque_Derecha3")
	else:
		animacion.play("Ataque_Salto_Derecha")
		$Timer_Ataque.start()



func attack_state_arr(): #Se activa la hitbox de arriba y su animación
	Hit=$Hit_Arriba/CollisionShape2D
	animacion.playback_speed=1.5
	#Hit.set_deferred("disabled",false)
	if on_ground==true:
		animacion.play("Ataque_Arriba")
	else: 
		animacion.play("Ataque_Salto_Arriba")
		$Timer_Ataque.start()

func attack_state_izq(): #Se activa la hitbox de la izquierda y su animación
	Hit=$Hit_Izquierda/CollisionShape2D
	animacion.playback_speed=1.5
	#Hit.set_deferred("disabled",false)
	if on_ground==true:
		if attack==1:
			animacion.play("Ataque_Izq")
		elif attack==2: 
			animacion.play("Ataque_Izq2")
		else:
			animacion.play("Ataque_Izq3")
	else: 
		animacion.play("Ataque_Salto_Izq")
		$Timer_Ataque.start()
	#$AnimatedSprite.flip_h=true


func attack_state_aba(): #Se activa la hitbox de abajo y su animación
	Hit=$Hit_Abajo/CollisionShape2D
	animacion.playback_speed=1.5
	#Hit.set_deferred("disabled",false)
	animacion.play("Ataque_Salto_Abajo")
	$Timer_Ataque.start()

func attack_animation_finished():  #Se acaba la animación, desabilitando
	#Hit.set_deferred("disabled",true)              #Se desactiva la hitbox, la que fuese
	animacion.playback_speed=1
	finish_knockback=true                          #Se acaba el knockback
	velocidad.y=4.1666                             #Se establece esta velocidad, para que el knockback no salga volando
	state=MOVE

func rodar_finished():
	Hurt.set_deferred("disabled",false)
	Hurt_Rodar.set_deferred("disabled",true)   #La hitbox de rodando se desabilita
	$ColisionRodar.disabled=true
	$Colision.disabled=false
	velocidad.y=10                 
	state=MOVE

func brinco():
	animacion.play("Brinco")
func finalizar_brinco():
	velocidad.y=4.1666
	state=MOVE   
func dano():
	if rodar_golpe==1:
		Hurt.disabled=false
		Hurt_Rodar.set_deferred("disabled",true)
		$ColisionRodar.disabled=true
		$Colision.disabled=false
		rodar_golpe=0
	flechaApuntar.visible = false
	animacion.play("Dano")
	#$SlowTime.startSlowMotion()

func recibir_dano():
	velocidad.y=4.1666 
	desactivarHit()
	if $Stun_Gorgona/Rayos.visible:
		$Stun_Gorgona/Rayos.visible=false
		$Stun_Gorgona/Light2D.energy=0
	if stats.health>0:
		state=MOVE

func desactivarHit():
	if Hit !=null:                        #Se desabilita la hitbox en caso de recibir daño en medio de animación
		Hit.set_deferred("disabled",true) #Antes era Hit.disabled=true, y ocurria un gran bug
		animacion.playback_speed=1 
		finish_knockback=true

func _on_Hurtbox_area_entered(area):
	if mirandoAbajo:
		$Tiempo_mirando_abajo.stop()
		$Camera2D.position.y=0
		mirandoAbajo=false
		state=MOVE
	if area.get_parent().name=="Agua":       #En el Agua de Caribdis, no recibe daño
		knockback=Vector2.ZERO
		desactivarHit()
		state=BRINCO
	else:
		if Global.noHit:
			dead()
		else:
			stats.health-=area.damage
			$Hurtbox.start_invincibility(0.8)
			$Stun_Gorgona/CollisionShape2D.set_deferred("disabled",true)
			knockback=Vector2.ZERO
			desactivarHit()
			if stats.health>0:
				interferencia=global_position - area.global_position
				rodar_golpe=0
				$SlowTime.startSlowMotion(0.5)
				if $Sprite.flip_h:
					$Blood.position.x = 19
					$Blood.flip_h = true
				else: 
					$Blood.position.x = -19
					$Blood.flip_h = false
				state=DANO


func _on_Hurt_rodar_area_entered(area):
	if area.get_parent().name=="Agua" || area.name=="Agua":       #En el Agua de Caribdis, no recibe daño
		knockback=Vector2.ZERO
		desactivarHit()
		state=BRINCO
	else:
		if Global.noHit:
			dead()
		else:
			stats.health-=area.damage
			$Hurtbox.start_invincibility(0.8)
			knockback=Vector2.ZERO
			if stats.health>0:
				rodar_golpe=1
				interferencia=global_position - area.global_position
				$SlowTime.startSlowMotion(0.5)
				if $Sprite.flip_h:
					$Blood.position.x = 19
					$Blood.flip_h = true
				else: 
					$Blood.position.x = -19
					$Blood.flip_h = false
				state=DANO

func dead():
	flechaApuntar.visible = false
	Global.playerDeadSong()
	state=DEAD

func muerto(delta):
	$Hurtbox/CollisionShape2D.set_deferred("disabled",true)
	$Hurt_rodar/CollisionShape2D.set_deferred("disabled",true)
	set_collision_layer_bit(1,false)
	if Hit!=null:
		Hit.set_deferred("disabled",true)
	velocidad.x=0
	velocidad.y += gravedad*delta            #Si mueres en el aire caes al suelo
	velocidad=move_and_slide(velocidad,Vector2(0,1))
	animacion.play("Muerto")
	$Hurtbox.collision_layer=false
	$Hurt_rodar.collision_layer=false

func muriendo():
	#Sirve para avisar a los canvas layers y que el fondo negro sea lo principal
	emit_signal("muriendo")

func signal_dead():
	if Global.noHit:
		Global.diedInNoHit()
	else:
		emit_signal("teletransporte_muerto")   
		stats.health=vida
		stats.max_health=vida

func _on_Hit_Arriba_area_entered(area):
	sonido_espada(area.name)

func _on_Hit_Abajo_area_entered(area):
	sonido_espada(area.name)
	finish_knockback=false
	knockback=Vector2.ZERO
	interferencia=global_position - area.global_position
	if velocidad.x==0:
		knockback.x=direccion *3
	else: knockback.x=0
	knockback.y=-2.3
	knockback=knockback*100

func _on_Hit_Derecha_area_entered(area):
	sonido_espada(area.name)
	if on_ground==true and area.name!="Objeto_Rompible":
		knockback=Vector2.ZERO
		interferencia=global_position - area.global_position
		knockback.x=sign(interferencia.x) 
		knockback.y=0
		knockback=knockback*100


func _on_Hit_Izquierda_area_entered(area):
	sonido_espada(area.name)
	if on_ground==true and area.name!="Objeto_Rompible":
		knockback=Vector2.ZERO
		interferencia=global_position - area.global_position
		knockback.x=sign(interferencia.x) 
		knockback.y=0
		knockback=knockback*100

func mirar_abajo():
	animacion.play("Mirar_hacia_abajo")
	
func _on_Tiempo_mirando_abajo_timeout():
	if on_ground and animacion.current_animation=="Idle":
		state=LOOK_DOWN

func _on_Jugador_luchando_con_boss(valorx, valory,direccion_vuelo):
	luchando_con_boss=true
	direccion_vuelo_empuje=direccion_vuelo
	luchando_con_boss_empuje.x=valorx
	luchando_con_boss_empuje.y=valory


func _on_Jugador_fin_de_empuje_boss():
	luchando_con_boss=false
	luchando_con_boss_empuje=Vector2.ZERO


func _on_Hurtbox_invincibility_ended():
	$BlinkAnimation.play("Stop")


func _on_Hurtbox_invincibility_started():
	$BlinkAnimation.play("Start")

func sonido_espada(area):
	if area=="Objeto_Rompible" or area=="Objeto_Pupa" or area=="Spikes":
		$AudioStreamPlayer2.stream=load("res://Sonidos/Espada/espada_1.wav")
	else:
		$AudioStreamPlayer2.stream=load("res://Sonidos/Espada/espada_2.wav")
	$AudioStreamPlayer2.play()

func sonido_random(nombre,fichero,numero):
	if nombre=="Suelo":
		fichero=Global.nombre_carpeta_suelo
		nombre=Global.nombre_audio_suelo
	var audio="res://Sonidos/"+fichero+"/"+ nombre+str(randi() % numero+1)+".wav"
	var sfx=load(audio)
	$AudioStreamPlayer.stream=sfx
	$AudioStreamPlayer.play()

func quitarAccionInputBuffer():
	inputBuffer.pop_front()

#Comprueba si esta atascado entre un pincho(u objeto) en el techo
#y el suelo
func stuck() -> bool:
	var space=get_world_2d().direct_space_state
	var query=Physics2DShapeQueryParameters.new()
	query.set_shape($Colision.shape)
	query.transform=$Colision.global_transform
	query.collision_layer=collision_mask
	var score=space.intersect_shape(query)
	for i in range(score.size()-1,-1,-1):
		var collider=score[i].collider
		var shape=score[i].shape
		if collider is CollisionObject2D && collider.is_shape_owner_one_way_collision_enabled(shape):
			score.remove(i)
	return score.size()==0

#############Movil#############################
func _on_Dialogo_controlesVisibles(visibilidad):
	$MobileControls/MobileButtons.visible=visibilidad
#############Movil#############################
func apuntando(delta):
	#Para que se siga cayendo y demás
	distancia.x=speed*delta
	velocidad.x=lerp(velocidad.x,(distancia.x*direccion)/delta,get_weight()) 
	velocidad.y += gravedad*delta
	velocidad.y=min(250, velocidad.y)
	corner_correction(5)
	velocidad=move_and_slide(velocidad,Vector2(0,-1),false,4,PI/4,false)
func noApunto(): #En la animación de apuntado, no le volvio a dar
	state = MOVE
#############Habilidades#####################
func habilidadAcabada(bicho):
	if bicho == "gorgona":
		habilidadVisibleGorgona.inicioCooldown()
	elif bicho == "caribdis":
		habilidadVisibleCaribdis.inicioCooldown()
	elif bicho == "serpopardo":
		habilidadVisibleSerpopardo.inicioCooldown()
		$CanvasLayer/HealthUI/Habilidades/HabilidadSerpopardo.eliminarCargaGancho()
	state=MOVE

func stun_gorgona():
	if sprite.flip_h==false:
		animacion.play("HabilidadDer_Stun_Gorgona")
	else: animacion.play("HabilidadIzq_Stun_Gorgona")

func _on_Stun_Gorgona_body_entered(body):
	cuerpoStuneadoGorgona=body
	emit_signal("comienzaStunGorgona",body)
	body.set_physics_process(false)
	$Stun_Gorgona/StunGorgona_Timer.start(2)

func _on_Stun_Gorgona_area_entered(area):   #Solo para areas especificas, como los tentáculos de Caribidis
	if area.name=="TentaculoArribaStun" || area.get_parent().name=="TentaculosAbajo":
		emit_signal("comienzaStunGorgona")
		cuerpoStuneadoGorgona=null
		$Stun_Gorgona/StunGorgona_Timer.start(2)

func _on_StunGorgona_Timer_timeout():
	emit_signal("acabaStunGorgona")
	if cuerpoStuneadoGorgona!=null:
		cuerpoStuneadoGorgona.set_physics_process(true)

func ola_caribdis():
	if sprite.flip_h==false:
		animacion.play("HabilidadDer_Ola_Caribdis")
	else:
		animacion.play("HabilidadIzq_Ola_Caribdis")

func saleOlaCaribdis():
	var bubbles=load("res://Escenas/ProyectilEspecialDeJugador.tscn")
	var bubbles_instance=bubbles.instance()
	var direccionBurbuja
	if posicionProyectiles.position==Vector2(14,8):
		bubbles_instance.flipSprite=true
		direccionBurbuja=posicionProyectiles.global_position.x+500
	else: 
		bubbles_instance.flipSprite=false
		direccionBurbuja=posicionProyectiles.global_position.x-500
	bubbles_instance.direccion=posicionProyectiles.global_position.direction_to(Vector2(direccionBurbuja,posicionProyectiles.global_position.y))
	bubbles_instance.sprite="WaterShot"
	bubbles_instance.x_speed=150
	bubbles_instance.sonido="res://Sonidos/Jefes/CaribdisBurbujas.wav"
	nodoPadre.add_child(bubbles_instance)
	bubbles_instance.global_position=posicionProyectiles.global_position


func fisicas_gancho(delta):
	# Hook physics
	var walk = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	if $CuelloGancho.hooked:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		velocidadGancho = to_local($CuelloGancho.cabeza).normalized() * GANCHO_PULL
		if velocidadGancho.y > 0:
			# Pulling down isn't as strong
			velocidadGancho.y *= 0.35
		else:
			# Pulling up is stronger
			velocidadGancho.y *= 1.25
		if sign(velocidadGancho.x) != sign(walk):
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			velocidadGancho.x *= 0.7
	else:
		# Not hooked -> no chain velocity
		velocidadGancho = Vector2(0,0)
	
	#Movimiento en Gancho
	distancia.x=speed*delta
	velocidad.x=lerp(velocidad.x,(distancia.x*walk)/delta,get_weight()) #Creo que es una interpolación
	velocidad.y += gravedad*delta
	velocidad.y=min(250, velocidad.y)
	corner_correction(5)
	velocidad += velocidadGancho
	velocidad=move_and_slide(velocidad,Vector2(0,-1),false,4,PI/4,false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("habilidad") && state == APUNTANDO:
		# We clicked the mouse -> shoot()
		flechaApuntar.visible = false
		$CuelloGancho.shoot(flechaApuntar.position, sprite.flip_h)
		animacion.play("Idle") #*************************CAMBIAR POR ANIMACION
		$SlowTime.is_active = false
		Engine.time_scale = 1
		habilidadAcabada("serpopardo")
		state = GANCHO_SERPOPARDO
	elif Input.is_action_just_released("habilidad") && state == GANCHO_SERPOPARDO:
		# We released the mouse -> release()
		$CuelloGancho.release()
		ganchoAbilitado = false
		state = MOVE
