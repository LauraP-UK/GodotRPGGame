@tool
extends LoadDataNode

class_name LoadZoneDataNode

@export var linked_ID: String = "";

func get_facing_direction() -> DirectionsType:
	return Directions.get_from_simple(move_direction);

func proccess_load_node(storey:Storey, owning_level:Level):
	self.owning_level = owning_level;
	self.local_grid_pos = get_coords();
	self.storey = storey;

func can_send() -> bool:
	return linked_ID != "" && linked_scene != "";

func _process(delta):
	if !Engine.is_editor_hint():
		return;
	update_visuals();
