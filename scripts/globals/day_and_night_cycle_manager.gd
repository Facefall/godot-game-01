extends Node

const MINUTES_PER_DAY: int = 24 * 60
const MINUTES_PER_HOUR: int = 60

# 游戏分钟的持续时间
# TAU = 2 * Pi
const GAME_MINUTE_DURATION: float = TAU / MINUTES_PER_DAY


var game_speed: float = 5.0
var initial_day: int = 1
var initial_hour: int = 12
var initial_minute: int = 30

var time:float = 0.0

var current_mintues: int = -1
var current_day: int = -1


signal game_time(time: float)
signal time_tick(day: int, hour: int, minute: int)
signal time_tick_day(day: int)

func _ready() -> void:
	set_initial_time()
	
func _process(delta: float) -> void:
	time += delta * game_speed * GAME_MINUTE_DURATION
	game_time.emit(time)
	
	recalculate_time()


func set_initial_time() -> void: 
#	初始总分钟数
	var initial_total_minutes = initial_day * MINUTES_PER_DAY + (initial_hour * MINUTES_PER_HOUR) + initial_minute
	
#	游戏时间
	time = initial_total_minutes * GAME_MINUTE_DURATION
	

func recalculate_time() -> void:
	var total_minutes = int(time / GAME_MINUTE_DURATION)
	var day = int(total_minutes / MINUTES_PER_DAY)
	
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute: int = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if current_mintues != minute:
		current_mintues = minute
		time_tick.emit(day, hour, minute)
	
	if current_day != day:
		current_day = day
		time_tick_day.emit(day)
