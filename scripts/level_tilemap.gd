extends TileMapLayer

const PORT = 7777
const MAX_CLIENTS = 20

@onready var player: Player:
	set(value):
		player = value
		if player:
			checkpoint_sound = player.get_node("CheckpointSound")
@onready var shader_material: ShaderMaterial = owner.material
@onready var checkpoint_sound: AudioStreamPlayer2D
@onready var players: Node2D = $"../Players"

func _process(_delta: float) -> void:
	if not player:
		player = players.get_node(str(Global.get_id()))
		return
	var tile_pos = local_to_map(to_local(player.global_position))
	if get_cell_atlas_coords(tile_pos) == Tiles.CHECKPOINT:
		var data = get_cell_tile_data(tile_pos)
		var from_white = data.get_custom_data("from_white")
		var from_gray = data.get_custom_data("from_gray")
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(
			shader_material,
			"shader_parameter/from_white",
			from_white,
			0.6
		)
		tween.parallel().tween_property(
			shader_material,
			"shader_parameter/from_gray",
			from_gray,
			0.6
		)
		checkpoint_sound.play()
		set_cell(tile_pos, 0, Tiles.CHECKPOINT_COMPLETE)
		var spawnpoint = to_global(map_to_local(tile_pos))
		player.spawnpoint = player.get_parent().to_local(spawnpoint)
		player.save()
		Save.save()
