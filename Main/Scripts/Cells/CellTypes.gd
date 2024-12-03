extends Node

class_name CellTypes

static var OPEN: CellType = CellType.create("OPEN", OpenTile);
static var SOLID: CellType = CellType.create("SOLID", SolidTile);
static var ONE_WAY: CellType = CellType.create("ONE_WAY", OneWayTile, 1.0, OneWayDeserialiser);
static var ICE: CellType = CellType.create("ICE", IceTile, 2.5);
static var BRIDGE: CellType = CellType.create("BRIDGE", BridgeTile, 1.0, BridgeDeserialiser);
static var STEPS: CellType = CellType.create("STEPS", StepsTile, 1.0, StepsDeserialiser);

static func  get_all() -> Array[CellType]:
	return [OPEN, SOLID, ONE_WAY, ICE, BRIDGE, STEPS];

static func get_from_name(type_name: String) -> CellType:
	for type in get_all():
		if (type.navmesh_id == type_name): return type;
	print("ERROR: CellTypes.get_from_data() : No tile found for type: ", type_name);
	return null;
