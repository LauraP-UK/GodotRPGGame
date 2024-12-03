extends Overlay
class_name BlackFade

var animation_player:AnimationPlayer = null;
var rect:ColorRect = null;

static var FADE_IN:String = "FadeIn";
static var FADE_OUT:String = "FadeOut";

var on_faded_in_task:Callable;
var on_faded_out_task:Callable;

func _ready():
	animation_player = $AnimationPlayer;
	rect = $ColorRect;
	rect.visible = false;
	rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
	rect.size_flags_vertical = Control.SIZE_EXPAND_FILL;
	rect.z_index = 4000;
	_on_resized();

func _on_resized():
	rect.size = get_viewport().size;

func on_faded_in(callable:Callable):
	self.on_faded_in_task = callable;

func on_faded_out(callable:Callable):
	self.on_faded_out_task = callable;

func _on_anim_finished(anim_name):
	if (anim_name == FADE_IN):
		if (on_faded_in_task != null && on_faded_in_task.is_valid()): on_faded_in_task.call();
		fade_out();
	else:
		if (on_faded_out_task != null && on_faded_out_task.is_valid()): on_faded_out_task.call();
		Scheduler.run_later(1, Callable(self, "hide_rect"));

func fade_in():
	animation_player.play(FADE_IN);
	show_rect();

func fade_out():
	animation_player.play(FADE_OUT);

func show_rect(ignore = null):
	rect.visible = true;

func hide_rect(ignore = null):
	rect.visible = false;

static func create(callable:Callable, data_node:LoadZoneDataNode) -> BlackFade:
	var scene_load:PackedScene = load("res://Main/Prefabs/Overlays/BlackFade.tscn");
	var overlay:Node2D = scene_load.instantiate();
	
	var fade:BlackFade = (overlay as BlackFade);
	fade.on_faded_in(callable.bind(data_node));
	
	return overlay;
