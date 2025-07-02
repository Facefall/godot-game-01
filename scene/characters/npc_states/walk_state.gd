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
#	fixed: physics_frame => process_frame
#	等待第一个物理帧结束 
#Godot 内部的随机数生成器可能在游戏启动时，在物理帧开始时具有一个相对固定的初始状态。如果你在第一个物理帧立即调用 map_get_random_point，它每次都可能从相同的初始状态开始生成随机数，导致结果一致
#当你 await get_tree().process_frame 时，你等待的是一个渲染帧的结束。在一个渲染帧期间，游戏会处理各种事件、更新逻辑、播放动画等。这期间，很可能已经有足够的内部状态变化（包括随机数生成器的状态），使得在你调用 map_get_random_point 时，它能生成不同的随机点
	await get_tree().process_frame
	
	set_movement_target()
	
func set_movement_target() -> void:
	var map_id = navigation_agent_2D.get_navigation_map()
	var map_layer = navigation_agent_2D.navigation_layers
	
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(map_id, map_layer, false)
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
