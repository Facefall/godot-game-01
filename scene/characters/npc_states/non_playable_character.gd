class_name NonPlayableCharacter
extends CharacterBody2D

@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 6

var walk_cycles: int = 0
var current_walk_cycles: int
