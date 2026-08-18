extends Sprite2D
func _ready():
	_update_scale()
func _process(_delta):
	_update_scale()
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://main_menu.tscn")
func _update_scale():
	if texture:
		var viewport_size = get_viewport_rect().size
		var texture_size = texture.get_size()
		position = viewport_size/2
