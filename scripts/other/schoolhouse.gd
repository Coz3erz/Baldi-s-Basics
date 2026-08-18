extends Node2D
@onready var tilemap = $floor
@onready var player = $player
var door = [false,self]
func replace_tiles_with_source(source_id):
	var used_cells = tilemap.get_used_cells()
	for cell in used_cells:
		tilemap.set_cell(cell,source_id,Vector2(0,0))
func _ready():
	replace_tiles_with_source(randi_range(1,3))
