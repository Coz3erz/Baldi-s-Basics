extends Sprite2D
var time = 0
func _ready():
	randomize()
	# Set the modulate property with a random color
	modulate = Color(randf(), randf(), randf(), 1.0)
func _process(delta):
	time += 0.06
	position.y += sin(time) 
func _on_notebook_area_entered(area):
	if area.name == "player_hitbox":
		$"../../player".notebooks += 1
		$"../../player".stamina = 100
		$"../../player".seven_notebooks()
		queue_free()
