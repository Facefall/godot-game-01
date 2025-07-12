extends Control
@onready var day_label: Label = $DayPanel/MarginContainer/DayLabel
@onready var time_label: Label = $TimePanel/MarginContainer/TimeLabel

@export var normal_speed: int = 1
@export var fast_speed: int = 100
@export var cheet_speed: int = 300

func _ready() -> void:
	DayAndNightCycleManager.time_tick.connect(on_time_tick)

func on_time_tick (day: int, hour: int, minute: int ) -> void:
	day_label.text = "DAY " + str(day)
	time_label.text = "%d:%d" % [hour, minute]
	
func _on_normal_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = normal_speed


func _on_fast_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = fast_speed


func _on_cheat_speed_button_2_pressed() -> void:
	DayAndNightCycleManager.game_speed = cheet_speed
