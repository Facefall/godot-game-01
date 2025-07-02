extends NonPlayableCharacter

@export var need_walk: bool = true


func _ready() -> void:
	if need_walk == true:
		walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
		
	print('walk_cycles: ', walk_cycles)
