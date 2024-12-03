@tool
extends Resource

class_name CharacterType

var name: String;
var sprite_sheet: Texture;
var class_type: GDScript;
var simple_type: Characters.SIMPLE_TYPE;

func _init(name: String, sprite_sheet: Texture, class_type: GDScript, simple_type: Characters.SIMPLE_TYPE):
	self.name = name;
	self.sprite_sheet = sprite_sheet;
	self.class_type = class_type;
	self.simple_type = simple_type;

func spawn(grid_position: Vector2, controller_class: GDScript) -> Node2D:
	var actor_scene = preload("res://Main/Prefabs/Actors/Actor.tscn");
	var actor_instance = actor_scene.instantiate();
	
	var script_path: String = class_type.resource_path;
	var actor_script = load(script_path);
	actor_instance.set_script(actor_script);
	
	var controller_instance = controller_class.new();
	
	(actor_instance as Actor).setup(self, controller_instance);
	
	actor_instance.position = grid_position * GameManager.TILE_SIZE;
	
	return actor_instance;

func is_player() -> bool:
	return self == Characters.PLAYER;

static func create(name: String, sprite_sheet_ref: String, class_type: GDScript, simple_type: Characters.SIMPLE_TYPE) -> CharacterType:
	return CharacterType.new(name, load(sprite_sheet_ref), class_type, simple_type);
