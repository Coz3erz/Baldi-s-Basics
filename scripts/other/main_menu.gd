extends Sprite2D
@onready var cam_target = $"."
var target_zoom = 1.0
func _ready():
	_update_scale()
	$AudioStreamPlayer2D.play()
func _process(_delta):
	$Camera2D.global_position = cam_target.global_position
	if cam_target == $".":
		$Camera2D.position.y -= 27
	$Camera2D.zoom.x = lerp($Camera2D.zoom.x,target_zoom,0.05)
	$Camera2D.zoom.y = lerp($Camera2D.zoom.y,target_zoom,0.05)
func _update_scale():
	if texture:
		var viewport_size = get_viewport_rect().size
		var texture_size = texture.get_size()
		position.x = viewport_size.x/2
		position.y = viewport_size.y/3
func _on_audio_stream_player_2d_finished():
	get_tree().quit()
func _on_button_pressed():
	cam_target = $Node
	target_zoom = 0.45
func _on_button_2_pressed():
	cam_target = $"."
	target_zoom = 1.0
func _on_button_3_pressed():
	cam_target = $Node2
	target_zoom = 0.5
func _on_button_4_pressed():
	cam_target = $Node
	target_zoom = 0.45
func _on_button_5_pressed():
	get_tree().change_scene_to_file("res://schoolhouse.tscn")
