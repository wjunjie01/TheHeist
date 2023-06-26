extends Node

const SAVE_FILE = "user://save_file.tscn"
var user_data = {} #dictionary that stores the progress

func _ready():
	load_data()

func save_data():
	#Creates a file and open the file that we make, overwrite it with
	# all the variables in the new file
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	#stores the data of the file in the dictionary
	file.store_var(user_data)
	file.close()

func load_data():
	#if the file save_file does not exist, start from level 0
	if not FileAccess.file_exists(SAVE_FILE):
		user_data = {
			"level" : 0,
		}
		save_data()
	#if the user played before, and has some data from last time
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	user_data = file.get_var() #get the variables from the last time
	#user_data is a global script
	file.close()
