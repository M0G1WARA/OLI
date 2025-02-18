extends Node

var config_file_path = "user://config.cfg"
var config = ConfigFile.new()
var settings = {  
	"ollama": {
		"model": "",
		"server":"http://127.0.0.1:11434/"
	},
	"interface": {
		"language": "English",
		"horizontal movement": true,
		"timer": 5,
	}
}

func save_config():
	for category in settings.keys():
		for key in settings[category].keys():
			config.set_value(category, key, settings[category][key])
	config.save(config_file_path)


func load_config():
	if config.load(config_file_path) == OK:
		for category in settings.keys():
			if config.has_section(category):
				for key in settings[category].keys():
					settings[category][key] = config.get_value(category, key, settings[category][key])
	else:
		save_config()
