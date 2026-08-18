extends Sprite2D
var area_loop = false
var shut = preload("res://sounds/map/Doors_StandardShut.wav")
var open = preload("res://sounds/map/Doors_StandardOpen.wav")
func _process(delta):
	if area_loop and $AnimationPlayer.current_animation != "door_opening":
		$AnimationPlayer.play("stay_open")
func _on_detector_area_entered(area):
	if area.name != "area" and area.name != "nav_finish" and area.name != "player_cheese":
		area_loop = true
		$AudioStreamPlayer2D.stream = open
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("door_opening")
		if area.name == "player_hitbox":
			$"../..".door = [true,self]
			$"../../player_pos".position = position
func _on_detector_area_exited(area):
	if area.name != "area" and area.name != "nav_finish" and area.name != "player_cheese":
		area_loop = false
		$AudioStreamPlayer2D.stream = shut
		$AnimationPlayer.play("door_closing")
		$AudioStreamPlayer2D.stream = shut
		$AudioStreamPlayer2D.play()
		$Timer.start()
func _on_timer_timeout():
	if $"../..".door == [true,self]:
		$"../..".door = [false,self]
