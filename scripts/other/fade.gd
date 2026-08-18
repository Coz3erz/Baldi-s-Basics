extends TileMapLayer

const TILE_BLACK := Vector2i(0, 0)
const TILE_FADE := Vector2i(1, 0)
const TILE_TRANSPARENT := Vector2i(2, 0)

@onready var player = $"../player"
@onready var source_id = 0  # Uses first source in the TileSet

var faded_tiles: Dictionary = {}

func _physics_process(_delta):
	var player_pos: Vector2i = local_to_map(player.global_position)
	reveal_tile(player_pos)

	for pos in faded_tiles.keys():
		if pos.distance_to(player_pos) > 5:
			reset_tile(pos)

func reveal_tile(start: Vector2i):
	var queue: Array = [start]
	var visited: Dictionary = {}

	while not queue.is_empty():
		var pos: Vector2i = queue.pop_front()
		if visited.has(pos):
			continue
		visited[pos] = true

		var tile_coords := get_cell_atlas_coords(pos)
		if tile_coords == TILE_BLACK:
			set_cell(pos, source_id, TILE_FADE)
			faded_tiles[pos] = TILE_BLACK
			queue.append_array(get_neighbors(pos))
		elif tile_coords == TILE_FADE:
			set_cell(pos, source_id, TILE_TRANSPARENT)
			faded_tiles[pos] = TILE_FADE

func reset_tile(pos: Vector2i):
	var tile_coords := get_cell_atlas_coords(pos)
	if tile_coords == TILE_TRANSPARENT:
		set_cell(pos, source_id, TILE_FADE)
	elif tile_coords == TILE_FADE:
		set_cell(pos, source_id, TILE_BLACK)
	faded_tiles.erase(pos)

func get_neighbors(pos: Vector2i) -> Array:
	return [
		pos + Vector2i(1, 0),
		pos + Vector2i(-1, 0),
		pos + Vector2i(0, 1),
		pos + Vector2i(0, -1),
	]
