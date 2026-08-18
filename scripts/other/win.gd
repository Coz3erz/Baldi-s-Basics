extends Sprite2D

func _ready():
	_update_scale()
	$AudioStreamPlayer2D.play()
func _process(_delta):
	_update_scale()
func _update_scale():
	if texture:
		var viewport_size = get_viewport_rect().size
		var texture_size = texture.get_size()
		scale = viewport_size / texture_size
		position = viewport_size/2
func _on_audio_stream_player_2d_finished():
	get_tree().quit()
