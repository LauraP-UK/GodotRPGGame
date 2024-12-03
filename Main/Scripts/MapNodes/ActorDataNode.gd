@tool
extends DataNode

class_name ActorDataNode

@export var NPC_Type: Characters.SIMPLE_TYPE = Characters.SIMPLE_TYPE.PLAYER:
	set(value):
		NPC_Type = value;
		if (NPC_Type == Characters.SIMPLE_TYPE.PLAYER): controller_type = Controllers.SIMPLE_TYPE.PLAYER;
		update_visual_representation();
@export var controller_type: Controllers.SIMPLE_TYPE = Controllers.SIMPLE_TYPE.STATIC:
	set(value):
		if (NPC_Type == Characters.SIMPLE_TYPE.PLAYER):
			controller_type = Controllers.SIMPLE_TYPE.PLAYER;
			return;
		controller_type = value;
@export var start_direction: Directions.CARDINAL_SIMPLE_DIRECTION = Directions.CARDINAL_SIMPLE_DIRECTION.SOUTH:
	set(value):
		start_direction = value;
		update_visual_representation();
@export var start_storey: int = 0:
	set(value):
		start_storey = value;
		self.z_index = value;

var actual_actor_id:int = -1;

func _process(delta):
	if !Engine.is_editor_hint():
		return;
	update_visuals();

func update_visuals(force_update:bool = false):
	var parent_pos:Vector2 = ($CharacterSprite.get_parent() as Node2D).position;
	if (last_pos == parent_pos && !force_update): return;
	var snap_pos:Vector2 = GameManager.get_snapped_pos($CharacterSprite.get_parent());
	var offset:Vector2 = snap_pos + Vector2(GameManager.TILE_SIZE/2, GameManager.TILE_SIZE/2);
	$CharacterSprite.position = offset + Vector2(0,-8);
	last_pos = parent_pos;

func process_actor(level:Level) -> Actor:
	if Engine.is_editor_hint():
		return;
	
	var npc_type: CharacterType = Characters.get_by_simple(NPC_Type);
	
	if (npc_type.is_player() && LevelController.i().player != null):
		return null;
	
	var controller: GDScript = Controllers.get_by_simple(controller_type);
	var spawn_at: Vector2 = GameManager.real_position_to_grid(self.position) + level.placed_at;
	var start_dir: DirectionsType = Directions.get_from_simple(start_direction);
	
	var game_manager: GameManager = GameManager.i();
	var level_controller:LevelController = LevelController.i();
	
	if (npc_type != Characters.PLAYER && (npc_type == null || controller == null)):
		print("Malformed Actor! : ", npc_type if npc_type == null else npc_type.name, " - ", controller, " at ", spawn_at);
		return null;
	
	var actor:Actor;
	if (npc_type == Characters.PLAYER): actor = Characters.PLAYER.spawn(spawn_at, PlayerController);
	else: actor = npc_type.spawn(spawn_at, controller);
	
	actor.storey = (start_storey * GameManager.STOREY_MULTIPLIER) + 1;
	actor.z_index = actor.storey;
	
	for child:Node in actor.get_children(true):
		if (child is Node2D): child.z_index = actor.z_index;
	level_controller.actor_layer.add_child(actor);
	
	if (start_dir != null): actor.set_idle_direction(start_dir);
	
	actual_actor_id = actor.get_instance_id();
	return actor;


func update_visual_representation():
	if !Engine.is_editor_hint():
		return;
	
	var actor_type:CharacterType = Characters.get_by_simple(NPC_Type);
	if (actor_type == null): return;
	
	var start_dir: DirectionsType = Directions.get_from_simple(start_direction);
	if (start_dir == null || !start_dir.is_cardinal()): start_dir = Directions.SOUTH;
	
	$CharacterSprite.texture = actor_type.sprite_sheet;
	match start_dir.simple_direction:
		Directions.SIMPLE_DIRECTION.NORTH:
			$AnimationPlayer.play(AnimationStates.DEFAULT.get_animation(AnimationStates.AnimationType.IDLE_NORTH));
		Directions.SIMPLE_DIRECTION.EAST:
			$AnimationPlayer.play(AnimationStates.DEFAULT.get_animation(AnimationStates.AnimationType.IDLE_EAST));
		Directions.SIMPLE_DIRECTION.SOUTH:
			$AnimationPlayer.play(AnimationStates.DEFAULT.get_animation(AnimationStates.AnimationType.IDLE_SOUTH));
		Directions.SIMPLE_DIRECTION.WEST:
			$AnimationPlayer.play(AnimationStates.DEFAULT.get_animation(AnimationStates.AnimationType.IDLE_WEST));
