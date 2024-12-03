extends BehaviourDeserialiser

class_name OneWayDeserialiser

static func deserialise(json_data: Dictionary) -> OneWayTile:
	var enter_dirs_text = json_data["enter_directions"];
	var exit_dir_text = json_data["exit_direction"];
	
	var enter_dirs: Array[DirectionsType] = [];
	var exit_dir: DirectionsType = Directions.get_from_name(exit_dir_text);
	
	for entry in enter_dirs_text:
		enter_dirs.append(Directions.get_from_name(entry));
		
	return OneWayTile.new(enter_dirs, exit_dir);
