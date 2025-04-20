extends Node

signal update_color(enabled : bool)

func save_file(file_name : String, variable):
	var file := FileAccess.open("user://" + file_name + ".var", FileAccess.WRITE)
	file.store_var(variable)
	file.close()

func load_file(file_name : String, on_fail = null):
	var file := FileAccess.open("user://" + file_name + ".var", FileAccess.READ)
	if file:
		var data = file.get_var()
		file.close()
		return data
	else:
		print("requested file " + file_name + ".var does not exist, returning default")
		return on_fail
