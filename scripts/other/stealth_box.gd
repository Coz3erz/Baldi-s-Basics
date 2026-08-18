extends Sprite2D
var area_loop = false
func _ready():
	modulate.a = 0.9
func _process(delta):
	if area_loop:
		if modulate.a > 0:
			modulate.a -= 0.05
	else:
		if modulate.a < 1:
			modulate.a += 0.05
func _on_area_area_entered(area):
	if area.name == "player_hitbox":
		area_loop = true
func _on_area_area_exited(area):
	if area.name == "player_hitbox":
		area_loop = false
