@tool
extends LoadDataNode
class_name SoftLoadDataNode

@export var x_axis:bool = false:
	set(val):
		x_axis = val;
		if (x_axis && (move_direction != LOAD_DIRECTIONS.NORTH && move_direction != LOAD_DIRECTIONS.SOUTH) ||
			!x_axis && (move_direction != LOAD_DIRECTIONS.EAST && move_direction != LOAD_DIRECTIONS.WEST)):
			var new_dir:DirectionsType = Directions.get_from_simple(move_direction).get_cw();
			match new_dir.simple_direction:
				Directions.SIMPLE_DIRECTION.NORTH: move_direction = LOAD_DIRECTIONS.NORTH;
				Directions.SIMPLE_DIRECTION.EAST: move_direction = LOAD_DIRECTIONS.EAST;
				Directions.SIMPLE_DIRECTION.SOUTH: move_direction = LOAD_DIRECTIONS.SOUTH;
				Directions.SIMPLE_DIRECTION.WEST: move_direction = LOAD_DIRECTIONS.WEST;
			
		update_rec();
@export var neg_offset:int = 0:
	set(val):
		neg_offset = 0 if (val < 0) else val;
		update_rec();
@export var pos_offset:int = 0:
	set(val):
		pos_offset = 0 if (val < 0) else val;
		update_rec();

func get_covered_tiles() -> Array[Vector2]:
	var return_arr:Array[Vector2] = [];
	var cur_pos:Vector2 = get_global_grid_position();
	var offset:Vector2 = Vector2(1,0) if x_axis else Vector2(0,1);
	for i in range(-neg_offset, pos_offset + 1):
		var tile_pos:Vector2 = cur_pos + (offset * i);
		return_arr.append(tile_pos);
	return return_arr;

func process_load(data:SoftLoadData, storey:Storey, owning_level:Level):
	self.owning_level = owning_level;
	self.local_grid_pos = get_coords();
	data.add_or_compute(self.linked_scene, self);
	self.storey = storey;

func _process(delta):
	if !Engine.is_editor_hint():
		return;
	update_visuals();
	var parent_pos:Vector2 = ($ColorRect.get_parent() as Node2D).position;
	if (last_pos == parent_pos): return;
	update_rec_pos();
	last_pos = parent_pos;

func update_rec():
	var total_length: int = 1 + neg_offset + pos_offset;
	var new_size:Vector2 = Vector2(1 if !x_axis else total_length, 1 if x_axis else total_length) * GameManager.TILE_SIZE;
	$ColorRect.size = new_size;
	update_visuals(true);

func update_visuals(force_update:bool = false):
	var parent_pos:Vector2 = ($ColorRect.get_parent() as Node2D).position;
	if (last_pos == parent_pos && !force_update): return;
	update_rec_pos();
	update_markers();
	last_pos = parent_pos;

func update_markers():
	var snap_pos:Vector2 = GameManager.get_snapped_pos($ColorRect.get_parent());
	var offset:Vector2 = snap_pos + Vector2(GameManager.TILE_SIZE/2, GameManager.TILE_SIZE/2);
	$Arrow.position = offset;
	$Sprite2D.position = offset + Vector2(0,-2);

func update_rec_pos():
	var snap_pos:Vector2 = GameManager.get_snapped_pos($ColorRect.get_parent());
	var offset:Vector2 = Vector2(neg_offset, neg_offset) * GameManager.TILE_SIZE * -1;
	if (x_axis): offset.y = 0;
	else: offset.x = 0;
	$ColorRect.position = snap_pos + offset;
