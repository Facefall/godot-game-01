extends Sprite2D

@onready var hurt_component: HurtComponents = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scene/objects/trees/log.tscn")

func _ready() -> void:
	print("ready")
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)
	
func on_hurt(hit_damage: int) -> void:
	print("on hurt")
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 1)
	await get_tree().create_timer(0.8).timeout
	material.set_shader_parameter("shake_intensity", 0.0)
	
func on_max_damaged_reached() -> void:
	print("max damage reached")
	call_deferred("add_log_scene")
	queue_free()

func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
