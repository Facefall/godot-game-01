extends Sprite2D

@onready var hurt_component: HurtComponents = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var stone_scene = preload("res://scene/objects/rocks/stone.tscn")

func _ready() -> void:
	print("ready rock")
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)
	
func on_hurt(hit_damage: int) -> void:
	print("on hurt")
	damage_component.apply_damage(hit_damage)

func on_max_damaged_reached() -> void:
	print("max damage reached")
	call_deferred("add_stone_scene")
	queue_free()

func add_stone_scene() -> void:
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)
