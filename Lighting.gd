extends Node2D

onready var main_bolt = $MainBolt
var jaggedness_max = 20
var jaggedness_min = 10
var jaggedness_scale = 3
var bolt_length_factor = 150
var max_num_of_branches = 4

var num_of_bisects = 7

var positionMove=true
export var randomLighting=true
export var y_axis=0
export var x_axis_left=0
export var x_axis_right=0
export (String) var playerScene="."
onready var player=get_tree().get_root().get_node(playerScene)

func ready():
	main_bolt.add_point(Vector2(0,0))

func _process(delta):
	if positionMove && randomLighting:
		var driftPosition=[-50,50,100,-100,0]
		position.x=player.global_position.x + driftPosition[randi() % driftPosition.size()]

func movePosition():
	positionMove=true

func _on_Timer_timeout():
	# Main Bolt
	if randomLighting:
		positionMove=false
		var random=RandomNumberGenerator.new()
		random.randomize()
		var random_X=random.randf_range(player.global_position.x-x_axis_left,player.global_position.x+x_axis_right)
		for child in main_bolt.get_children().size():
			main_bolt.get_child(child).queue_free()
		create_lightning(main_bolt, Vector2(random_X,y_axis))
		var num_of_branches = randi() % max_num_of_branches
		for branch in num_of_branches:
			create_branch(main_bolt, Vector2(random_X,y_axis))
		$LightingAnimation.play("Flash")
		var times=[7,8,9,10,12,15,18,20]
		$Timer.start(times[randi()% times.size()])
	else:
		for child in main_bolt.get_children().size():
			main_bolt.get_child(child).queue_free()
		create_lightning(main_bolt, Vector2(x_axis_left,y_axis))
		var num_of_branches = randi() % max_num_of_branches
		for branch in num_of_branches:
			create_branch(main_bolt, Vector2(x_axis_left,y_axis))
		$LightingAnimation.play("Flash")

func create_lightning(bolt, target_pos):
	var length = target_pos - position 
	bolt.clear_points()
	bolt.add_point(Vector2(0,0))
	bolt.add_point(target_pos - position)
	
	var persistance = 1.0
	
	for bisect in num_of_bisects:
		var local_array = bolt.points
		for point in local_array.size() - 1:
			var start = local_array[point]
			var end = local_array[point + 1]
			var mid = (end - start) / 2
			var vec = (end - start).normalized()
			var normal = Vector2(vec.y, -vec.x)
			
			var rand_scale = rand_range(jaggedness_min, jaggedness_max) * random_pos_or_neg()
			var new_point = start  + mid + (rand_scale * jaggedness_scale * (length / bolt_length_factor) * persistance * normal)
			persistance *= 0.8
			
			bolt.add_point(new_point, (point * 2) + 1)

func create_branch(branch_from_bolt, target_pos):
	var new_branch = Line2D.new()
	new_branch.default_color = branch_from_bolt.default_color
	new_branch.texture = branch_from_bolt.texture
	new_branch.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	new_branch.position = branch_from_bolt.points[randi() % branch_from_bolt.points.size()]
	branch_from_bolt.add_child(new_branch)
	var new_target = target_pos - new_branch.position + Vector2(rand_range(0.0, 100.0), rand_range(0.0, 100.0))
	create_lightning(new_branch, new_target)
	
func random_pos_or_neg():
	var s = bool(randi() % 2)
	if s:
		 return 1 
	else:
		return -1


