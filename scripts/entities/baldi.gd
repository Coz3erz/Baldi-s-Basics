extends CharacterBody2D
@export var speed = 25
# Reference to the NavigationAgent2D child
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation = $baldi_sprite/AnimationPlayer
@onready var feet_raycast: RayCast2D = $feetraycast
@onready var head_raycast: RayCast2D = $headraycast
@onready var audiostream = $audio_stream
@onready var chase = $pursuit
var time_slap = 1
var pursuit_overdrive = false # after the player is out of baldis sight for a little while baldi still knows thier position
var slapping = false #slapping lol
var pursuit = false #chase mode for baldi boolean
var calculation_threshold = 0 # path is calculated every variable amount of frames
var calc_tld = 0 # function variable used with calculation threshold
# Current velocity used for movement
func _ready():
	# Enable obstacle avoidance
	nav_agent.avoidance_enabled = true
	# Connect the signal to receive computed velocity
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	velocity = Vector2.ZERO
	set_destination($"../player_pos".global_position)
	$slap_timer.start(time_slap)
func _physics_process(delta):
	if $"../player".exits > 2 and !$screech.playing and !$"../player".caught:
		$screech.play()
	time_slap = 1.7 - (0.1*$"../player".notebooks)
	chase.target_position = $"../player".position - position
	if animation.current_animation != "slap":
		animation.play("neutral")
	if calc_tld > calculation_threshold:
		calc_tld = 0
		set_destination($"../player_pos".global_position)
	else:
		calc_tld += 1 * delta
	if pursuit_overdrive:
		relocate($"../player".position)
	if chase.is_colliding() and chase.get_collider().name == "player":
		pursuit = true
		pursuit_overdrive = false
		relocate($"../player".position)
	else:
		if pursuit == true:
			pursuit = false
			pursuit_overdrive = true
			$pursuit_buff.start()
	# If we're not at the destination, follow the path
		# Advanc$"../player"e toward next waypoint
	if slapping:
		#pathfinding and velocity
		set_destination($"../player_pos".global_position)
		var next_path_point = nav_agent.get_next_path_position()
		var direction = (next_path_point - global_position) * speed * delta
		nav_agent.set_velocity(direction * speed)
	else:
		nav_agent.set_velocity(Vector2.ZERO)
		set_destination($"../player_pos".global_position)
	# Apply the velocity computed from collision avoidance
	velocity *= speed
	move_and_slide()
	velocity /= speed
	#raycast scripts
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
#idk
func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
#set destination
func set_destination(target_position: Vector2):
	# Public method to set destination
	nav_agent.target_position = target_position
#start slapping motion
func _on_slap_timer_timeout():
	$slap_time.start()
	animation.play("slap")
	$sound_timer.start()
	slapping = true
#stop slapping motion
func _on_slap_time_timeout():
	slapping = false
	$slap_timer.start(time_slap)
#play sound
func _on_sound_timer_timeout():
	audiostream.play()
func global_relocate(_position):
	$"../player_pos".global_position = _position
func relocate(position_):
	$"../player_pos".position = position_
func _on_entity_area_entered(area):
	if area.name == "nav_finish":
		pursuit = false
		var children = $"../stealth_boxes".get_children()
		var random = children[randi() % children.size()]
		relocate(random.global_position)
func _on_pursuit_buff_timeout():
	pursuit_overdrive = false
func _on_screech_finished():
	if !$"../player".caught and $"../player".exits > 2:
		$screech.play()
