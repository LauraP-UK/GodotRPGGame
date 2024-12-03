@tool
extends Node

class_name AnimationStates

enum AnimationType {IDLE_NORTH, IDLE_EAST, IDLE_SOUTH, IDLE_WEST, MOVING_NORTH, MOVING_EAST, MOVING_SOUTH, MOVING_WEST};

static var DEFAULT: AnimationState = AnimationState.create("IdleUp", "IdleRight", "IdleDown", "IdleLeft", "WalkUp", "WalkRight", "WalkDown", "WalkLeft");
static var SLIDING: AnimationState = AnimationState.create("IdleUp", "IdleRight", "IdleDown", "IdleLeft", "SlideUp", "SlideRight", "SlideDown", "SlideLeft");
static var CANT_MOVE: AnimationState = AnimationState.create("IdleUp", "IdleRight", "IdleDown", "IdleLeft", "WalkUp", "WalkRight", "WalkDown", "WalkLeft", 0.4);
