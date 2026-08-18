extends CharacterBody2D
@onready var feet_raycast = $feetraycast
@onready var head_raycast = $headraycast
@onready var nav_agent = $NavigationAgent2D
@onready var chase = $pursuit
var state = 0 # 0 = wander , 1 = chase
var speed = 1000
var area_loop = false
var area_
var update = false
func _ready():
	randomize()
	# Enable obstacle avoidance
	nav_agent.avoidance_enabled = true
	# Connect the signal to receive computed velocity
	velocity = Vector2.ZERO
	set_destination($"../principal_point".global_position)
	wander()
func _process(delta):
	if update:
		$"../CanvasLayer/detention".visible = true
		$"../CanvasLayer/detention".text = "you have detention!
		"+str(int(round($detention_timer.time_left)))+ " seconds remain!"
	else:
		$"../CanvasLayer/detention".visible = false
	if chase.is_colliding() and chase.get_collider().name == "player" and $"../player".sprint == true:
		state = 1
	var next_path_point = nav_agent.get_next_path_position()
	var direction = (next_path_point - global_position).normalized()
	set_velocity(direction * speed)
	if feet_raycast.is_colliding():
		var hit_position = feet_raycast.get_collision_point()
		var origin = feet_raycast.global_position
		var total_length = feet_raycast.target_position.length()
		var hit_distance = origin.distance_to(hit_position)
		if hit_distance < total_length:
			var penetration_depth = total_length - hit_distance
			var push_direction = -feet_raycast.target_position.normalized()
			global_position += push_direction * penetration_depth
	# Resolve top (head) penetration
	if head_raycast.is_colliding():
		var hit_position = head_raycast.get_collision_point()
		var origin = head_raycast.global_position
		var total_length = head_raycast.target_position.length()
		var hit_distance = origin.distance_to(hit_position)

		if hit_distance < total_length:
			var penetration_depth = total_length - hit_distance
			var push_direction = -head_raycast.target_position.normalized()
			global_position += push_direction * penetration_depth
	move_and_slide()
func set_destination(target_position: Vector2):
	nav_agent.target_position = target_position
func _on_navigation_agent_2d_navigation_finished():
	wander()
func _on_entity_area_entered(area):
	area_loop = true
	area_ = area
func wander():
		randomize()
		var children = $"../stealth_boxes".get_children()
		var random = children[randi() % children.size()]
		if random.name == 'stealth_box11':
			wander()
			return
		$"../principal_point".position = random.position
func _on_entity_area_exited(area):
	area_loop = false
func detention_block(time):
	$detention_timer.start(time)
	update = true
	$"../detention_block".process_mode = Node.PROCESS_MODE_ALWAYS
func _on_detention_timer_timeout():
	$"../detention_block".process_mode = Node.PROCESS_MODE_DISABLED
	update = false
