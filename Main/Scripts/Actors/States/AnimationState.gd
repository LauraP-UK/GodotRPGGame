extends Node

class_name AnimationState

var animations: Dictionary  = {};
var play_speed: float = 1.0;

func get_animation(type: AnimationStates.AnimationType) -> String:
	return animations[type];

static func create(north_idle: String, east_idle: String, south_idle: String, west_idle: String, north_moving: String, east_moving: String, south_moving: String, west_moving: String, playback_speed: float = 1.0) -> AnimationState:
	var state: AnimationState = AnimationState.new();
	
	state.play_speed = playback_speed;
	
	state.animations[AnimationStates.AnimationType.IDLE_NORTH] = north_idle;
	state.animations[AnimationStates.AnimationType.IDLE_EAST] = east_idle;
	state.animations[AnimationStates.AnimationType.IDLE_SOUTH] = south_idle;
	state.animations[AnimationStates.AnimationType.IDLE_WEST] = west_idle;
	
	state.animations[AnimationStates.AnimationType.MOVING_NORTH] = north_moving;
	state.animations[AnimationStates.AnimationType.MOVING_EAST] = east_moving;
	state.animations[AnimationStates.AnimationType.MOVING_SOUTH] = south_moving;
	state.animations[AnimationStates.AnimationType.MOVING_WEST] = west_moving;
	
	return state;
