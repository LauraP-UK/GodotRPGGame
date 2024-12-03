extends DataNode
class_name LoadDataNode

enum LOAD_DIRECTIONS {
	NORTH = Directions.SIMPLE_DIRECTION.NORTH,
	EAST = Directions.SIMPLE_DIRECTION.EAST,
	SOUTH = Directions.SIMPLE_DIRECTION.SOUTH,
	WEST = Directions.SIMPLE_DIRECTION.WEST
}

@export var ID: String = "";
@export var linked_scene: String = "";
@export var move_direction: LOAD_DIRECTIONS = LOAD_DIRECTIONS.NORTH:
	set(value):
		move_direction = value;
		update_arrow();

var storey:Storey = null;
var local_grid_pos:Vector2 = VectorUtils.get_null();
var owning_level:Level = null;

func get_move_direction() -> DirectionsType:
	return Directions.get_from_simple(move_direction);

func get_global_grid_position() -> Vector2:
	return owning_level.placed_at + local_grid_pos;

func get_coords() -> Vector2:
	return GameManager.real_position_to_grid(self.position);

func update_visuals(force_update:bool = false):
	var parent_pos:Vector2 = ($Arrow.get_parent() as Node2D).position;
	if (last_pos == parent_pos && !force_update): return;
	var snap_pos:Vector2 = GameManager.get_snapped_pos($Arrow.get_parent());
	var offset:Vector2 = snap_pos + Vector2(GameManager.TILE_SIZE/2, GameManager.TILE_SIZE/2);
	$Arrow.position = offset;
	$Sprite2D.position = offset + Vector2(0,-2);
	last_pos = parent_pos;

func update_arrow():
	if !Engine.is_editor_hint():
		return;
	
	var coords:Vector2;
	match move_direction:
		LOAD_DIRECTIONS.NORTH: coords = Vector2(0,1);
		LOAD_DIRECTIONS.EAST: coords = Vector2(2,1);
		LOAD_DIRECTIONS.SOUTH: coords = Vector2(1,1);
		LOAD_DIRECTIONS.WEST: coords = Vector2(3,1);
		_: coords = Vector2(-1,-1);
	
	coords.x *= ICON_SIZE;
	coords.y *= ICON_SIZE;
	
	$Arrow.region_rect.position = coords;
