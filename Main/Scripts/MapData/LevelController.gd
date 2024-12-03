extends Node
class_name LevelController

static var level_controller:LevelController = null;
var loaded_levels:Dictionary = {};

var current_level:Level = null;

var actor_layer:Node2D = null;
var level_load:Node2D = null;

var player:Player = null;
var npcs:Array[Actor] = [];

func _init():
	if (level_controller != null): return;
	level_controller = self;

func _process(delta):
	if (player != null): player.controller._tick(delta);
	
	for level:Level in loaded_levels.values():
		level.tick(delta);

func _ready():
	actor_layer = $Actors;
	level_load = $LevelLoad;
	level_load.y_sort_enabled = true;
	
	load_level("res://Main/Prefabs/MapLevels/TestLevels/TestLevel3.tscn", true);

static func i() -> LevelController:
	return level_controller;

func get_all_actors(storey:int) -> Array[Actor]:
	var actors:Array[Actor] = [];
	for npc in npcs:
		if (npc.storey == storey): actors.append(npc);
	if (player != null && player.storey == storey): actors.append(player);
	return actors;

func get_actor_by_node(actor_node:ActorDataNode) -> Actor:
	if (actor_node.NPC_Type == Characters.PLAYER.simple_type): return player;
	for npc in npcs:
		if (npc.get_instance_id() == actor_node.actual_actor_id): return npc;
	print("ERR: LevelController.get_actor_by_node() : Could not find actor with Instance ID: ", actor_node.actual_actor_id);
	return null;

func get_navmesh(actor:Actor) -> TileMapLayer:
	var storey:Storey = get_storey(actor);
	if (storey == null): return null;
	return storey.navmesh;

func check_load(actor:Actor, last_position:Vector2 = VectorUtils.get_null(), to_position:Vector2 = VectorUtils.get_null()):
	var storey:Storey = get_storey(actor);
	if (storey == null): return;
	
	if (VectorUtils.is_null(last_position)):
		for load_node:LoadZoneDataNode in storey.get_loading_data_nodes():
			if (actor.grid_position == load_node.get_global_grid_position() && load_node.can_send()):
				var overlay:BlackFade = BlackFade.create(Callable(self, "load_callable"), load_node);
				player.snap_overlay(overlay);
				overlay.fade_in();
				return;
	else:
		for load_node:SoftLoadDataNode in storey.get_soft_load_nodes():
			if (load_node.get_covered_tiles().has(last_position)):
				var dir:DirectionsType = Directions.get_relative(last_position, to_position);
				if (dir == load_node.get_move_direction()): soft_change(load_node);
				return;

func soft_change(soft_node:SoftLoadDataNode):
	load_level(soft_node.linked_scene, true, false);

func load_callable(load_node:LoadZoneDataNode):
	load_level(load_node.linked_scene, true, true);
	var to_node:LoadZoneDataNode = current_level.find_load_node(load_node.linked_ID);
	player.teleport_to((to_node.storey.storey * GameManager.STOREY_MULTIPLIER) + 1, to_node.get_global_grid_position());
	player.set_idle_direction(load_node.get_facing_direction());
	player.controller.queue_movement(load_node.get_facing_direction());

func get_storey(actor:Actor) -> Storey:
	if (current_level == null): return null;
	var level:Level = null;
	if (actor.is_player()):
		level = current_level;
	else:
		for active in get_active_levels():
			if (active.has_actor(actor)):
				level = active;
	return level.storeys[actor.storey / GameManager.STOREY_MULTIPLIER];

func get_active_levels() -> Array[Level]:
	var return_arr:Array[Level] = [];
	for key in loaded_levels.keys():
		var loaded:Level = loaded_levels[key];
		if (loaded.is_active): return_arr.append(loaded);
	return return_arr;

func unload_all(dont_unload:Array[String] = []):
	current_level = null;
	npcs.clear();
	
	for key in loaded_levels.keys().duplicate():
		if (dont_unload.has(key)): continue;
		var level:Level = loaded_levels.get(key);
		level.scene.queue_free();
		loaded_levels.erase(key);
	
	for actor_node:Node2D in actor_layer.get_children():
		if (!(actor_node as Actor).is_player()): 
			actor_node.queue_free();

func load_level(file_path:String, is_main:bool, unload:bool = false, load_data_node:LoadDataNode = null) -> Level:
	if (unload): unload_all();
	var level:Level = null;
	
	if (loaded_levels.has(file_path)):
		level = loaded_levels[file_path];
		if (is_main):
			self.current_level = level;
			for key in loaded_levels.keys(): loaded_levels[key].call_deferred("deactivate");
			level.call_deferred("propagate_activate");
		return level;
	
	level = Level.new(file_path, load_data_node);
	level_load.add_child(level.scene);
	loaded_levels[file_path] = level;
	if (is_main): self.current_level = level;
	level.process_data_nodes();
	
	if (is_main):
		for key in loaded_levels.keys(): loaded_levels[key].call_deferred("deactivate");
		level.call_deferred("propagate_activate");
	
	return level;
