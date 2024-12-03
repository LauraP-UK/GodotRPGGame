extends BehaviourDeserialiser

class_name StepsDeserialiser

static func deserialise(json_data: Dictionary) -> StepsTile:
	var top: int = int(json_data["top"]);
	var bottom: int = int(json_data["bottom"]);
	return StepsTile.new(top, bottom);
