extends Node

class_name Controller

enum MOVE_RESULT {BLOCKED, BUSY, NONE, NO_ACTOR_ERR}

var owner_actor: Actor;
var movement_queue: Array[DirectionsType] = [];

func setup(owner_actor: Actor) -> void:
	self.owner_actor = owner_actor;
	register_events();

func register_events() -> void:
	pass;

func unregister_events() -> void:
	pass;

func _tick(delta: float) -> void:
	process_movement_queue();
	update_controller(delta);

func queue_movement(direction: DirectionsType) -> void:
	movement_queue.append(direction);

func queue_movement_path(path: Array[DirectionsType]) -> void:
	movement_queue.append_array(path);

func process_movement_queue() -> void:
	if (movement_queue.size() > 0):
		var next_direction: DirectionsType = movement_queue[0];
		
		var result:MOVE_RESULT = move_actor(next_direction);
		if (result == MOVE_RESULT.NONE):
			movement_queue.remove_at(0);
		else:
			if (result == MOVE_RESULT.BLOCKED): set_cant_walk(next_direction);
			return;

func update_controller(delta: float) -> void:
	pass;

func try_move_actor(direction: DirectionsType) -> bool:
	if (movement_queue.is_empty()):
		return move_actor(direction) == MOVE_RESULT.NONE;
	return false;

func move_actor(direction: DirectionsType) -> MOVE_RESULT:
	if (owner_actor):
		var dest: Vector2 = direction.get_relative(owner_actor.grid_position);
		var actors: Array[Actor] = LevelController.i().get_all_actors(owner_actor.storey);
		actors.erase(owner_actor);
		for actor in actors:
			if (actor.grid_position == dest && actor.storey == owner_actor.storey): return MOVE_RESULT.BLOCKED;
		
		if (!can_move(direction)): return MOVE_RESULT.BLOCKED;
		
		var set_success: bool = owner_actor.set_destination(direction);
		if (set_success):
			get_tile_behaviour(owner_actor.grid_position).on_step_off(owner_actor, direction);
			get_tile_behaviour(direction.get_relative(owner_actor.grid_position)).on_step_on(owner_actor, direction);
			return MOVE_RESULT.NONE;
		return MOVE_RESULT.BUSY;
	print("ERROR: Controller.move_actor() : Controller has no owner actor and had been instructed to move!");
	return MOVE_RESULT.NO_ACTOR_ERR;

func set_idle(direction: DirectionsType) -> void:
	if (owner_actor && movement_queue.is_empty()):
		owner_actor.set_idle_direction(direction);

func can_move(direction: DirectionsType) -> bool:
	var pos: Vector2 = owner_actor.grid_position;
	var dest: Vector2 = direction.get_relative(pos);
	
	var on_behaviour: TileBehaviour = get_tile_behaviour(pos);
	var dest_behaviour: TileBehaviour = get_tile_behaviour(dest);
	
	var can_step_off:bool = on_behaviour.can_step_off(owner_actor, direction);
	var can_step_on:bool = dest_behaviour.can_step_on(owner_actor, direction.get_opposite());
	
	return can_step_off && can_step_on;

func set_cant_walk(direction: DirectionsType):
	owner_actor.animation_state = AnimationStates.CANT_MOVE;
	owner_actor.current_direction = direction;
	owner_actor.set_walking_animation();

func get_navmesh_cell(coord: Vector2i) -> TileData:
	var level_controller:LevelController = LevelController.i();
	var nav_pos:Vector2i = coord - Vector2i(level_controller.current_level.placed_at.floor());
	return LevelController.i().get_navmesh(owner_actor).get_cell_tile_data(nav_pos);

func get_tile_behaviour(grid_position: Vector2) -> TileBehaviour:
	var cell_data: TileData = get_navmesh_cell(grid_position);
	var fallback_behaviour: TileBehaviour = CellTypes.OPEN.get_behaviour(cell_data);
	
	if (cell_data == null): return fallback_behaviour;
	
	var json_data = JSON.parse_string(cell_data.get_custom_data("JSON"));
	if (json_data == null): return fallback_behaviour;
	
	var cell_name: String = (json_data as Dictionary)["tile_type"];
	var cell_type: CellType = CellTypes.get_from_name(cell_name);
	return cell_type.get_behaviour(cell_data).set_info(grid_position, cell_type.movement_speed);

func on_start_move(last_tile:Vector2, next_tile:Vector2):
	check_soft_load(last_tile, next_tile);

func on_end_move():
	check_load();

func check_soft_load(last_tile:Vector2, next_tile:Vector2):
	pass;

func check_load():
	pass;
