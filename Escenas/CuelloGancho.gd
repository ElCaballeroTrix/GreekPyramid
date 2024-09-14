extends Node2D

#video: https://www.youtube.com/watch?v=Wzrw6_KDMl4
onready var links = $Cuerpo		# A slightly easier reference to the links
onready var cabezaSprite = $Cabeza/SpriteCabeza
var direction := Vector2(0,0)	# The direction in which the chain was shot
var cabeza := Vector2(0,0)			# The global position the tip should be in
								# We use an extra var for this, because the chain is 
								# connected to the player and thus all .position
								# properties would get messed with when the player
								# moves.

const SPEED = 50	# The speed with which the chain moves

var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall

# shoot() shoots the chain in a given direction
func shoot(dir: Vector2, flipped:bool) -> void:
	if flipped:
		links.flip_h = false
		cabezaSprite.flip_h = false
	else: 
		links.flip_h = true
		cabezaSprite.flip_h = true
	direction = dir.normalized()	# Normalize the direction and save it
	flying = true					# Keep track of our current scan
	cabeza = self.global_position		# reset the tip position to the player's position

# release() the chain
func release() -> void:
	flying = false	# Not flying anymore	
	hooked = false	# Not attached anymore

# Every graphics frame we update the visuals
func _process(_delta: float) -> void:
	self.visible = flying or hooked	# Only visible if flying or attached to something
	if not self.visible:
		return	# Not visible -> nothing to draw
	var tip_loc = to_local(cabeza)	# Easier to work in local coordinates
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	links.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	$Cabeza.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	links.position = tip_loc						# The links are moved to start at the tip
	links.region_rect.size.y = tip_loc.length()		# and get extended for the distance between (0,0) and the tip


# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	$Cabeza.global_position = cabeza	# The player might have moved and thus updated the position of the tip -> reset it
	if flying:
		# if move_and_collide()` always moves, but returns true if we did collide
		if $Cabeza.move_and_collide(direction * SPEED):
			hooked = true	# Got something!
			flying = false	# Not flying anymore
	cabeza = $Cabeza.global_position	# set `tip` as starting position for next frame
