extends VBoxContainer

enum {
	HOUR24,
	HOUR12,
	HOUR24SECONDS,
	HOUR12SECONDS
}

enum {
	FULL,
	SHORTENEDWEEKDAY,
	NOWEEKDAY,
	MONTHDAY,
	NUMBERSMONTHFIRST,
	NUMBERSDAYFIRST,
	NUMBERSMONTHDAY,
	NUMBERSDAYMONTH,
}

const MONTHS = {
	1: "January", 
	2: "February", 
	3: "March", 
	4: "April", 
	5: "May", 
	6: "June", 
	7: "July", 
	8: "August", 
	9: "September", 
	10: "October", 
	11: "November", 
	12: "December"
}

const WEEKDAYS = {
	0: ["Sunday", "Sun"],
	1: ["Monday", "Mon"],
	2: ["Tuesday", "Tue"],
	3: ["Wednesday", "Wed"],
	4: ["Thursday", "Thu"],
	5: ["Friday", "Fri"],
	6: ["Saturday", "Sat"]
}

const SEC_UPDATE_TIME = 1.0
const MIN_UPDATE_TIME = 10.0
#const PERFORMANCE_UPDATE_TIME = 60.0

@onready var timer: Timer = $Timer
@onready var time: Label = $Time
@onready var date: Label = $Date

var month_first : bool = true
var buffer_time : bool = false
var buffer_date : bool = true
var time_format : int = HOUR12
var date_format : int = SHORTENEDWEEKDAY
var update_time : float = 1.0

var prev_time_format : int = HOUR24

func _ready() -> void:
	time_format = Global.load_file("time", time_format)
	date_format = Global.load_file("date", date_format)
	buffer_time = Global.load_file("buffer_time", buffer_time)
	buffer_date = Global.load_file("buffer_date", buffer_date)
	update()
	timer.start(1.0)
	#Global.performance_mode.connect(performance)
	

func _process(delta: float):
	pass
	#print(Time.get_time_string_from_system())


func update():
	var datetime = Time.get_datetime_dict_from_system().duplicate()
	match time_format:
		HOUR24:
			time.text = (("0" if buffer_time and datetime["hour"] < 10 else "") + str(datetime["hour"]) + ":" +
				("0" if datetime["minute"] < 10 else "") + str(datetime["minute"]))
		HOUR12:
			var pm : bool = datetime["hour"] > 12
			if pm: datetime["hour"] -= 12
			if datetime["hour"] == 0: datetime["hour"] = 12
			time.text = (
				("0" if buffer_time and datetime["hour"] < 10 else "") + str(datetime["hour"]) + ":" + 
				("0" if datetime["minute"] < 10 else "") + str(datetime["minute"]) + " " +
				("PM" if pm else "AM"))
		HOUR24SECONDS:
			time.text = (("0" if buffer_time and datetime["hour"] < 10 else "") + str(datetime["hour"]) + ":" +
				("0" if datetime["minute"] < 10 else "") + str(datetime["minute"]) + ":" +
				("0" if datetime["second"] < 10 else "") + str(datetime["second"]))
				
		HOUR12SECONDS:
			var pm : bool = datetime["hour"] > 12
			if pm: datetime["hour"] -= 12
			if datetime["hour"] == 0: datetime["hour"] = 12
			time.text = (
				("0" if buffer_time and datetime["hour"] < 10 else "") + str(datetime["hour"]) + ":" + 
				("0" if datetime["minute"] < 10 else "") + str(datetime["minute"]) + ":" +
				("0" if datetime["second"] < 10 else "") + str(datetime["second"]) + " " +
				("PM" if pm else "AM"))
	
	match date_format:
		FULL: 
			date.text = WEEKDAYS[datetime["weekday"]][0] + ", " + MONTHS[datetime["month"]] + " " + str(datetime["day"]) + ", " + str(datetime["year"])
		
		SHORTENEDWEEKDAY: 
			date.text = WEEKDAYS[datetime["weekday"]][1] + ", " + MONTHS[datetime["month"]] + " " + str(datetime["day"]) + ", " + str(datetime["year"])
		
		NOWEEKDAY: 
			date.text = MONTHS[datetime["month"]] + " " + str(datetime["day"]) + ", " + str(datetime["year"])
		
		MONTHDAY: 
			date.text = MONTHS[datetime["month"]] + " " + str(datetime["day"])
		
		NUMBERSMONTHFIRST: 
			date.text = (
				("0" if buffer_date and datetime["month"] < 10 else "") + str(datetime["month"]) + "/" + 
				("0" if buffer_date and datetime["day"] < 10 else "") + str(datetime["day"]) + "/" + 
				str(datetime["year"]))
		
		NUMBERSDAYFIRST:
			date.text = (
				("0" if buffer_date and datetime["day"] < 10 else "") + str(datetime["day"]) + "/" + 
				("0" if buffer_date and datetime["month"] < 10 else "") + str(datetime["month"]) + "/" +
				str(datetime["year"]))
		
		NUMBERSMONTHDAY:
			date.text = (
				("0" if buffer_date and datetime["month"] < 10 else "") + str(datetime["month"]) + "/" + 
				("0" if buffer_date and datetime["day"] < 10 else "") + str(datetime["day"]))
		
		NUMBERSDAYMONTH:
			date.text = (
				("0" if buffer_date and datetime["day"] < 10 else "") + str(datetime["day"]) + "/" + 
				("0" if buffer_date and datetime["month"] < 10 else "") + str(datetime["month"]))


func _on_timer_timeout() -> void:
	update()
	timer.start(update_time)

#var performance : bool = false
#func _performance_mode(enabled : bool):
	#performance = enabled
	#if enabled:
		#update_time = PERFORMANCE_UPDATE_TIME
		#prev_time_format = time_format
		#match time_format:
			#HOUR12SECONDS:
				#time_format = HOUR12
			#HOUR24SECONDS:
				#time_format = HOUR24
	#else:
		#time_format = prev_time_format
		#if time_format == HOUR12 or time_format == HOUR24:
			#update_time = MIN_UPDATE_TIME
		#else:
			#update_time = SEC_UPDATE_TIME

func _on_date_button_pressed() -> void:
	match date_format:
		FULL: date_format = SHORTENEDWEEKDAY
		SHORTENEDWEEKDAY: date_format = NOWEEKDAY
		NOWEEKDAY: date_format = MONTHDAY
		MONTHDAY: date_format = NUMBERSMONTHFIRST
		NUMBERSMONTHFIRST: date_format = NUMBERSDAYFIRST
		NUMBERSDAYFIRST: date_format = NUMBERSMONTHDAY
		NUMBERSMONTHDAY: date_format = NUMBERSDAYMONTH
		NUMBERSDAYMONTH: 
			if buffer_date: date_format = NUMBERSMONTHFIRST
			else: date_format = FULL
			buffer_date = !buffer_date
			Global.save_file("buffer_date", buffer_date)
	
	Global.save_file("date", date_format)
	
	update()


func _on_time_button_pressed() -> void:
	match time_format:
		HOUR12: 
			time_format = HOUR12SECONDS
			update_time = SEC_UPDATE_TIME
		
		HOUR12SECONDS:
			time_format = HOUR24
			update_time = MIN_UPDATE_TIME
			
		HOUR24: 
			time_format = HOUR24SECONDS
			update_time = SEC_UPDATE_TIME
			
		HOUR24SECONDS:
			time_format = HOUR12
			update_time = MIN_UPDATE_TIME
			buffer_time = !buffer_time
			Global.save_file("buffer_time", buffer_time)
	
	Global.save_file("time", time_format)
	update()
	timer.start(update_time)
	
