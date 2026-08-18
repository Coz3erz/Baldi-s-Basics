extends StaticBody2D
func _ready():
	randomize()
	$sprite_2.disabled = true
	$sprite_1.disabled = true
	scale = Vector2(randi_range(4,5.5),randi_range(4,5.5))
	if randi_range(1,2) == 1:
		$desk.texture = preload("res://sprites/classroom_props/desk_1.png")
		$sprite_1.disabled = false
	else:
		$desk.texture = preload("res://sprites/classroom_props/desk_2.png")
		$sprite_2.disabled = false
	$desk.flip_h = bool(randi_range(0,1))
