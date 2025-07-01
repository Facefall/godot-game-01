extends NodeState

@export var character: NonPlayableCharacter
@export var animated_sprite_2d: AnimatedSprite2D

@export var navigation_agent_2D: NavigationAgent2D 

@export var min_speed:float = 5.0
@export var max_speed:float = 10.0

var speed: float

func _ready() -> void:
	navigation_agent_2D.velocity_computed.connect(on_safe_velocity_computed)
#	call_deferred 当前帧结束后再调用函数（空闲时间调用 
	call_deferred('character_setup')

	
func character_setup() -> void:
#	等待第一个物理帧结束
	await get_tree().physics_frame
	
	set_movement_target()
	
func set_movement_target() -> void:
	var map_id = navigation_agent_2D.get_navigation_map()
	var map_layer = navigation_agent_2D.navigation_layers
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(map_id,map_layer, false)
	navigation_agent_2D.target_position = target_position
	
	speed = randf_range(min_speed, max_speed)

func _on_process(_delta : float) -> void:
	pass	

func _on_physics_process(_delta : float) -> void:
	if navigation_agent_2D.is_navigation_finished():
		character.current_walk_cycles += 1
		set_movement_target()
		return
		
	var target_position: Vector2 = navigation_agent_2D.get_next_path_position()
	var target_direction: Vector2 = character.global_position.direction_to(target_position)
	
	var velocity: Vector2 = target_direction * speed
	
	if navigation_agent_2D.avoidance_enabled:
		animated_sprite_2d.flip_h = velocity.x < 0
		navigation_agent_2D.velocity = velocity
	else:
		character.velocity = velocity
		character.move_and_slide()

	
func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	animated_sprite_2d.flip_h = safe_velocity.x < 0
	character.velocity = safe_velocity
	character.move_and_slide()


func _on_next_transitions() -> void:
	if character.current_walk_cycles == character.walk_cycles:
	#if navigation_agent_2D.is_navigation_finished():
		print('finish')
		character.velocity = Vector2.ZERO
		transition.emit('Idle')


func _on_enter() -> void:
	animated_sprite_2d.play('walk')
	character.current_walk_cycles = 0

func _on_exit() -> void:
	animated_sprite_2d.stop()
