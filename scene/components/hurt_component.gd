class_name HurtComponents
extends Area2D

#树接受到伤害时，是来自于什么工具。
@export var tool: DataTypes.Tools = DataTypes.Tools.None
signal hurt

func _on_area_entered(area: Area2D) -> void:
	var hit_component = area as HitComponents
	print("hit")
	if tool == hit_component.current_tool:
		hurt.emit(hit_component.hit_damage)
