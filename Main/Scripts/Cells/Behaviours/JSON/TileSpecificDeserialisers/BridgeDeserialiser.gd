extends BehaviourDeserialiser

class_name BridgeDeserialiser

static func deserialise(json_data: Dictionary) -> BridgeTile:
	var dirs_text: Dictionary = json_data["storey_directions"];
	
	var storeys: Dictionary = {};
	
	for entry in dirs_text.keys():
		var directions: Array = dirs_text[entry];
		var dirs:Array[DirectionsType] = [];
		for dir in directions:
			dirs.append(Directions.get_from_name(dir));
		storeys[int(entry)] = dirs;
	
	return BridgeTile.new(storeys);
