extends Node
class_name Level

var storeys:Dictionary = {};
var path:String = "";
var scene:Node2D = null;
var placed_at:Vector2 = VectorUtils.get_null();

var is_active:bool = false;

func activate():
	self.is_active = true;
	scene.visible = true;
	for storey:Storey in storeys.values():
		for actor_node in storey.get_actor_data_nodes():
			var actor:Actor = LevelController.i().get_actor_by_node(actor_node);
			if (actor == null): continue;
			actor.visible = true;

func deactivate():
	self.is_active = false;
	scene.visible = false;
	for storey:Storey in storeys.values():
		for actor_node in storey.get_actor_data_nodes():
			var actor:Actor = LevelController.i().get_actor_by_node(actor_node);
			if (actor == null): continue;
			actor.visible = false;

func propagate_activate():
	activate();
	for node:SoftLoadDataNode in get_all_soft_loads():
		var to_activate:Level = LevelController.i().loaded_levels[node.linked_scene];
		to_activate.activate();

func tick(delta:float):
	if (!self.is_active): return;
	for storey:Storey in storeys.values():
		for actor_node in storey.get_actor_data_nodes():
			var actor:Actor = LevelController.i().get_actor_by_node(actor_node);
			if (actor == null): continue;
			var controller:Controller = LevelController.i().get_actor_by_node(actor_node).controller;
			if (controller != null): controller._tick(delta);

func _init(path:String, load_data_node:LoadDataNode = null):
	self.path = path;
	
	var packed_scene:PackedScene = load(path);
	self.scene = packed_scene.instantiate();
	
	var junk:Node2D = scene.find_child("Junk");
	if (junk != null): scene.remove_child(junk);
	
	var storey_node_parent:Node2D = self.scene.find_child("Storeys");
	for storey_node in storey_node_parent.get_children():
		var storey:Storey = Storey.new();
		var lower_layers:Node2D = storey_node.find_child("Lower");
		var data_nodes:Node2D = storey_node.find_child("DataNodes");
		var navmesh:TileMapLayer = storey_node.find_child("Navmesh");
		var id:int = int(String(storey_node.name));
		
		lower_layers.z_index = id * GameManager.STOREY_MULTIPLIER;
		for node:Node in lower_layers.get_children(true):
			if (node is Node2D): node.z_index = lower_layers.z_index;
		
		storey.lower_layers = lower_layers;
		storey.navmesh = navmesh;
		storey.storey = id;
		
		for node:DataNode in data_nodes.get_children().duplicate():
			storey.data_nodes.append(node);
			data_nodes.remove_child(node);
		
		self.storeys[id] = storey;
	
	self.placed_at = Vector2(0,0);
	if (load_data_node != null):
		var this_data_node:SoftLoadDataNode = find_soft_load_node(load_data_node.ID);
		if (this_data_node == null):
			print("ERROR: No linked SoftDataNode found for ", load_data_node.ID);
			return;
		
		var connecting_level:Level = load_data_node.owning_level;
		
		var global_line_up_point:Vector2 = load_data_node.get_move_direction().get_relative(connecting_level.placed_at + load_data_node.get_coords());
		self.placed_at = global_line_up_point - this_data_node.get_coords();
	scene.position = GameManager.grid_position_to_real(self.placed_at);

func process_data_nodes():
	var level_controller:LevelController = LevelController.i();
	for key in storeys.keys():
		var storey:Storey = storeys.get(key);
		
		var actors:Array[ActorDataNode] = storey.get_actor_data_nodes();
		var load_zones:Array[LoadZoneDataNode] = storey.get_loading_data_nodes();
		var soft_load_zones:Array[SoftLoadDataNode] = storey.get_soft_load_nodes();
		
		for actor_data_node:ActorDataNode in actors:
			var actor:Actor = actor_data_node.process_actor(self);
			if (actor == null): continue;
			if (actor.character_type == Characters.PLAYER): level_controller.player = actor;
			else: level_controller.npcs.append(actor);
		
		for load_data_node:LoadZoneDataNode in load_zones:
			load_data_node.proccess_load_node(storey, self);
		
		var soft_load_data:SoftLoadData = SoftLoadData.new();
		for soft_node:SoftLoadDataNode in soft_load_zones:
			soft_node.process_load(soft_load_data, storey, self);
		soft_load_data.load_levels();

func find_load_node(node_ID:String) -> LoadZoneDataNode:
	for storey:Storey in storeys.values():
		for load_node:LoadZoneDataNode in storey.get_loading_data_nodes():
			if (load_node.ID == node_ID): return load_node;
	return null;

func find_soft_load_node(node_ID:String) -> SoftLoadDataNode:
	for storey:Storey in storeys.values():
		for load_node:SoftLoadDataNode in storey.get_soft_load_nodes():
			if (load_node.ID == node_ID): return load_node;
	return null;

func get_all_soft_loads() -> Array[SoftLoadDataNode]:
	var return_arr:Array[SoftLoadDataNode] = [];
	for storey:Storey in storeys.values():
		return_arr.append_array(storey.get_soft_load_nodes());
	return return_arr;

func has_actor(actor:Actor) -> bool:
	for storey:Storey in storeys.values():
		for actor_node in storey.get_actor_data_nodes():
			if (actor_node.actual_actor_id == actor.get_instance_id()): return true;
	return false;
