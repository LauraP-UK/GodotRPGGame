@tool
extends Node2D

class_name GameManager

static var game_manager: GameManager = null;

static var TILE_SIZE: int = 16;
static var STOREY_MULTIPLIER: int = 2;

static func i() -> GameManager:
	return game_manager;

func _process(delta):
	if (InputController.i() == null): return;
	InputController.i()._process(delta);

func _init():
	InputController.new();
	self.game_manager = self;

static func real_position_to_grid(real_position: Vector2) -> Vector2:
	var x: int = floori(real_position.x / TILE_SIZE);
	var y: int = floori(real_position.y / TILE_SIZE);
	return Vector2(x,y);

static func grid_position_to_real(grid_position: Vector2) -> Vector2:
	return grid_position * TILE_SIZE;

static func get_snapped_pos(parent: Node2D, tile_size:int = TILE_SIZE):
	var parent_pos:Vector2 = parent.position;
	
	var mod_pos: Vector2 = Vector2(
		int(parent_pos.x) % tile_size,
		int(parent_pos.y) % tile_size
	);
	
	if (mod_pos.x < 0): mod_pos.x += tile_size;
	if (mod_pos.y < 0): mod_pos.y += tile_size;
	
	return mod_pos * -1;
