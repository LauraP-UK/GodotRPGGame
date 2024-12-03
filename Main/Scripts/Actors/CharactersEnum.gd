@tool
extends Node

class_name Characters

enum SIMPLE_TYPE {PLAYER, ALICE, BOB}

static var PLAYER: CharacterType = CharacterType.create("Player", "res://Main/Images/Tilesets/MainChar.png", Player, SIMPLE_TYPE.PLAYER);
static var NPC_1: CharacterType = CharacterType.create("Alice", "res://Main/Images/Tilesets/TestNPC1.png", NPC, SIMPLE_TYPE.ALICE);
static var NPC_2: CharacterType = CharacterType.create("Bob", "res://Main/Images/Tilesets/TestNPC2.png", NPC, SIMPLE_TYPE.BOB);

static func get_all() -> Array[CharacterType]:
	return [PLAYER, NPC_1, NPC_2];

static func get_by_name(actor_name: String) -> CharacterType:
	for actor in get_all():
		if (actor.name.to_upper() == actor_name.to_upper()): return actor;
	return null;

static func get_by_simple(simple_type: SIMPLE_TYPE) -> CharacterType:
	for actor in get_all():
		if (actor.simple_type == simple_type): return actor;
	return null;
