extends Node2D
var claim = false
@export var rotation_sign = 0
func _ready():
	$exit_sign.rotation_degrees = rotation_sign
	$wall.visible = false
	$wall/restriction.set_collision_layer_value(1,false)
	if name == "exit3":
		$"../exit3/wall".flip_v = true
func _on_exit_area_area_entered(area):
	if $"../../player".finale == true and area.name == "player_hitbox" and claim == false:
		$"../../player".exits += 1
		$"../../player".notebooks += 0.3
		claim = true
		$wall.visible = true
		$wall/restriction.set_collision_layer_value(1,true)
		$"../../Baldi".global_relocate(global_position)
		$"../../player".exit()
		$click.play()
