extends Node
class_name Storey

var storey:int = -10000;
var lower_layers:Node2D = null;
var navmesh:TileMapLayer = null;
var data_nodes:Array[DataNode] = [];

func get_actor_data_nodes() -> Array[ActorDataNode]:
	var return_arr:Array[ActorDataNode] = [];
	for node in data_nodes:
		if (node is ActorDataNode):
			return_arr.append(node as ActorDataNode);
	return return_arr;

func get_loading_data_nodes() -> Array[LoadZoneDataNode]:
	var return_arr:Array[LoadZoneDataNode] = [];
	for node in data_nodes:
		if (node is LoadZoneDataNode):
			return_arr.append(node as LoadZoneDataNode);
	return return_arr;

func get_soft_load_nodes() -> Array[SoftLoadDataNode]:
	var return_arr:Array[SoftLoadDataNode] = [];
	for node in data_nodes:
		if (node is SoftLoadDataNode):
			return_arr.append(node as SoftLoadDataNode);
	return return_arr;
