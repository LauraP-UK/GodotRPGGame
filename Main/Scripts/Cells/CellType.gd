extends Resource

class_name CellType

var navmesh_id: String;
var movement_speed: float = 1.0;
var behaviour_type: GDScript;
var deserialiser: GDScript = null;

func _init(navmesh_id: String, behaviour_type: GDScript, movement_speed: float, deserialiser: GDScript):
	self.navmesh_id = navmesh_id;
	self.behaviour_type = behaviour_type;
	self.movement_speed = movement_speed;
	self.deserialiser = deserialiser;

func get_behaviour(tile_data: TileData) -> TileBehaviour:
	if (deserialiser == null || tile_data == null): return behaviour_type.new();
	var result = JSON.parse_string(tile_data.get_custom_data("JSON"));
	return deserialiser.deserialise(result);

static func create(navmesh_id: String, behaviour_type: GDScript, movement_speed: float = 1.0, deserialiser: GDScript = null) -> CellType:
	return CellType.new(navmesh_id, behaviour_type, movement_speed, deserialiser);
