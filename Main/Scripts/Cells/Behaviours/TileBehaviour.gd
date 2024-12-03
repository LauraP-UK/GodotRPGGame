extends Node

class_name TileBehaviour

var coords: Vector2i;
var movement_speed: float = 1.0;

func _init():
	pass;

func set_info(coords: Vector2i, movement_speed: float) -> TileBehaviour:
	self.coords = coords;
	self.movement_speed = movement_speed;
	return self;

func can_step_on(actor: Actor, entering_direction: DirectionsType) -> bool:
	if (!_is_actor_free(actor)):
		return false;
	return _can_step_on(actor, entering_direction);

func can_step_off(actor: Actor, leaving_direction: DirectionsType) -> bool:
	return _can_step_off(actor, leaving_direction);

func _can_step_on(actor: Actor, entering_direction: DirectionsType) -> bool:
	return true;

func _can_step_off(actor: Actor, leaving_direction: DirectionsType) -> bool:
	return true;

func on_step_on(actor: Actor, entering_direction: DirectionsType) -> void:
	actor.speed_modifier = movement_speed;
	_on_step_on(actor, entering_direction);

func on_step_off(actor: Actor, leaving_direction: DirectionsType) -> void:
	_on_step_off(actor, leaving_direction);
	
func _on_step_on(actor: Actor, entering_direction: DirectionsType) -> void:
	pass;

func _on_step_off(actor: Actor, leaving_direction: DirectionsType) -> void:
	pass;

func _is_actor_free(ignore: Actor, direction: DirectionsType = Directions.SELF) -> bool:
	var actors: Array[Actor] = LevelController.i().get_all_actors(ignore.storey);
	actors.erase(ignore);
	for all_actor in actors:
		if (all_actor.storey == ignore.storey):
			if (all_actor.grid_position == direction.get_relative(coords)):
				return false;
	return true;
