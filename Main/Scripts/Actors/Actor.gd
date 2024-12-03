extends Node2D

class_name Actor

var current_direction: DirectionsType = Directions.SOUTH;
var is_walking: bool = false;
var is_moving: bool = false;
var step_1: bool = true;

static var MOVEMENT_ANIMATION_LENGTH: float = 0.30;
static var MOVEMENT_SPEED: float = (GameManager.TILE_SIZE / MOVEMENT_ANIMATION_LENGTH) * 0.5;

var grid_position: Vector2;
var target_grid_position: Vector2;
var from_grid_position: Vector2;
var time_since_last_movement: float = 0.0;

var storey: int = 0;
var animation_state: AnimationState = AnimationStates.DEFAULT;
var speed_modifier: float = CellTypes.OPEN.movement_speed;

var animation_player: AnimationPlayer;
var sprite_node: Sprite2D;
var character_type: CharacterType;

var controller: Controller;

func setup(character_type: CharacterType, controller_type: Controller) -> void:
	self.character_type = character_type;
	set_AI(controller_type);

func set_AI(controller_type: Controller) -> void:
	if (self.controller != null):
		self.controller.unregister_events();
		self.controller.owner_actor = null;
	
	self.controller = controller_type;
	self.controller.setup(self);

func _ready():
	animation_player = $AnimationPlayer;
	sprite_node = $CharacterSprite;
	sprite_node.texture = character_type.sprite_sheet;
	grid_position = self.position / GameManager.TILE_SIZE;
	update_screen_position();

func _process(delta):
	#if (controller): controller._tick(delta);
	move(delta);

func set_idle_direction(direction: DirectionsType) -> bool:
	if (is_moving): return false;
	current_direction = direction;
	set_idle_animation();
	return true;

func is_player() -> bool:
	return character_type.is_player();

func teleport_to(storey:int, position: Vector2 = Vector2(0,0)):
	stop_movement();
	controller.movement_queue.clear();
	target_grid_position = position;
	self.grid_position = position;
	self.storey = storey;
	update_screen_position();

func set_destination(direction: DirectionsType) -> bool:
	if (is_moving): return false;
	current_direction = direction;
	target_grid_position = grid_position + current_direction.offset;
	from_grid_position = grid_position;
	
	if (target_grid_position == grid_position):
		set_idle_animation();
		return true;
	
	is_moving = true;
	set_walking_animation();
	return true;

func move(delta: float) -> void:
	if (is_moving):
		if (time_since_last_movement == 0.0):
			controller.on_start_move(from_grid_position, target_grid_position);
		
		time_since_last_movement += delta;
		var progress: float = MathsF.ilerp_clamped(0.0, MOVEMENT_ANIMATION_LENGTH / speed_modifier, time_since_last_movement);
		var lerp_grid_pos = from_grid_position.lerp(target_grid_position, progress);
		grid_position = target_grid_position;
		update_screen_position(lerp_grid_pos);
		
		if (progress == 1.0):
			time_since_last_movement = 0.0;
			stop_movement();
			controller.on_end_move();

func stop_movement():
	is_moving = false;
	is_walking = false;
	step_1 = !step_1;
	set_idle_animation();

func update_screen_position(display_pos: Vector2 = grid_position):
	self.position = display_pos * GameManager.TILE_SIZE;
	self.z_index = storey;
	for node:Node in get_children():
		if (node is Node2D): node.z_index = storey;

func set_idle_animation() -> void:
	match current_direction.simple_direction:
		Directions.SIMPLE_DIRECTION.SOUTH:
			animation_player.play(animation_state.get_animation(AnimationStates.AnimationType.IDLE_SOUTH));
		Directions.SIMPLE_DIRECTION.NORTH:
			animation_player.play(animation_state.get_animation(AnimationStates.AnimationType.IDLE_NORTH));
		Directions.SIMPLE_DIRECTION.WEST:
			animation_player.play(animation_state.get_animation(AnimationStates.AnimationType.IDLE_WEST));
		Directions.SIMPLE_DIRECTION.EAST:
			animation_player.play(animation_state.get_animation(AnimationStates.AnimationType.IDLE_EAST));
	animation_player.speed_scale = animation_state.play_speed;

func set_walking_animation() -> void:
	match current_direction.simple_direction:
		Directions.SIMPLE_DIRECTION.SOUTH:
			animation_player.play(animation_state.get_animation(AnimationStates.AnimationType.MOVING_SOUTH));
		Directions.SIMPLE_DIRECTION.NORTH:
			animation_player.play(animation_state.get_animation(AnimationStates.AnimationType.MOVING_NORTH));
		Directions.SIMPLE_DIRECTION.WEST:
			animation_player.play(animation_state.get_animation(AnimationStates.AnimationType.MOVING_WEST));
		Directions.SIMPLE_DIRECTION.EAST:
			animation_player.play(animation_state.get_animation(AnimationStates.AnimationType.MOVING_EAST));
	if (animation_state == AnimationStates.DEFAULT):
		if (!step_1): animation_player.seek(MOVEMENT_ANIMATION_LENGTH, true);
		else: animation_player.seek(0.0, true);
	animation_player.speed_scale = animation_state.play_speed;
