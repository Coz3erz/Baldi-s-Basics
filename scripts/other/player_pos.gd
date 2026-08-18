extends Node2D

var cheese_prevent = false #to prevent some bug , use the logic man
func _on_player_cheese_area_entered(area):
	if area.name == "player_hitbox" and cheese_prevent == false and !$"../Baldi".pursuit and $"..".door[0] == false:
		$"../Baldi".global_relocate($"../player".global_position)
		cheese_prevent = true
		$cheese_prevent.start()
func _on_cheese_prevent_timeout():
	cheese_prevent = false
func _on_player_cheese_area_exited(area):
	if area.name == "player_hitbox" and cheese_prevent == false and !$"../Baldi".pursuit and $"..".door[0] == false:
		$"../Baldi".global_relocate($"../player".global_position)
		cheese_prevent = true
		$cheese_prevent.start()
