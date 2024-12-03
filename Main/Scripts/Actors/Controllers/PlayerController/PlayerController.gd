extends Controller

class_name PlayerController

var tracked_direction: DirectionsType = null;

func register_events() -> void:
	EventManager.register_listener(KeyPressEvent, self._on_move_event, owner_actor);
	EventManager.register_listener(KeyReleaseEvent, self._on_stop_move_event, owner_actor);

func unregister_events() -> void:
	EventManager.unregister_listener(KeyPressEvent, self._on_move_event);
	EventManager.unregister_listener(KeyReleaseEvent, self._on_stop_move_event);

func _on_move_event(event: KeyPressEvent):
	if (owner_actor.is_moving): return;
	
	var key_pressed:String = event.key_pressed;
	var dir: DirectionsType;
	
	match key_pressed:
		"W":
			dir = Directions.NORTH;
		"A":
			dir = Directions.WEST;
		"S":
			dir = Directions.SOUTH;
		"D":
			dir = Directions.EAST;
	
	if ((can_move(dir) && try_move_actor(dir)) || !movement_queue.is_empty()):
		tracked_direction = null;
		return;
	
	set_cant_walk(dir);
	tracked_direction = dir;

func _on_stop_move_event(event: KeyReleaseEvent):
	if (tracked_direction == null): return;
	
	var key_released:String = event.key_released;
	var dir: DirectionsType;
	
	match key_released:
		"W":
			dir = Directions.NORTH;
		"A":
			dir = Directions.WEST;
		"S":
			dir = Directions.SOUTH;
		"D":
			dir = Directions.EAST;
	
	if (dir == tracked_direction):
		owner_actor.animation_state = AnimationStates.DEFAULT;
		set_idle(dir);
		tracked_direction = null;

func check_load():
	LevelController.i().check_load(self.owner_actor);

func check_soft_load(last_tile:Vector2, next_tile:Vector2):
	LevelController.i().check_load(self.owner_actor, last_tile, next_tile);
