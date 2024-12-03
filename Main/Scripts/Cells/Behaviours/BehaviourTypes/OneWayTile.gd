extends TileBehaviour
class_name OneWayTile

var entry_directions: Array[DirectionsType];
var exit_direction: DirectionsType;

func _init(entry_directions: Array[DirectionsType], exit_direction: DirectionsType):
	self.entry_directions = entry_directions;
	self.exit_direction = exit_direction;

func _can_step_on(actor: Actor, entering_direction: DirectionsType) -> bool:
	return true;

func _can_step_off(actor: Actor, leaving_direction: DirectionsType) -> bool:
	return true;

func _on_step_on(actor: Actor, entering_direction: DirectionsType) -> void:
	actor.controller.queue_movement(exit_direction);

func _on_step_off(actor: Actor, leaving_direction: DirectionsType) -> void:
	pass;
