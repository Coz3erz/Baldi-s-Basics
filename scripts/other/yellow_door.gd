extends Sprite2D
var area_loop = false
var open = preload("res://sounds/map/Doors_Swinging.wav")
@export var sigma = 10
func _process(delta):
	if area_loop and $AnimationPlayer.current_animation != "door_opening":
		$AnimationPlayer.play("stay_open")
func _on_detector_area_entered(area):
	if area.name != "detector" and area.name != "area" and area.name != "nav_finish" and area.name != "player_cheese":
		area_loop = true
		$AnimationPlayer.play("door_opening")
		$AudioStreamPlayer2D.stream = open
		$AudioStreamPlayer2D.play()
		if area.name == "player_hitbox":
			$"../../..".door = [true,self]
			$"../../../player_pos".global_position = global_position
func _on_detector_area_exited(area):
	if area.name != "detector" and area.name != "area" and area.name != "nav_finish" and area.name != "player_cheese":
		area_loop = false
		$AnimationPlayer.play("door_closing")
		$Timer.start()
func _on_timer_timeout():
	if $"../../..".door == [true,self]:
		$"../../..".door = [false,self]
