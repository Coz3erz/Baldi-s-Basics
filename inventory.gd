extends Sprite2D
func _ready():
	_update_scale()
func _process(delta):
	_update_scale()
func _update_scale():
	if texture:
		var viewport_size = get_viewport_rect().size
		var texture_size = texture.get_size()
		position.y = 0
		position.x = viewport_size.x
