extends Node

var config_file_path = "user://config.cfg"
var config = ConfigFile.new()
var settings = {  
	"ollama": {
		"model": "",
		"server":"http://127.0.0.1:11434/"
	},
	"interface": {
		"language": "en",
		"horizontal movement": true,
		"vertical movement": false,
		"timer": 5,
		"resolution": Vector2i(120, 120),
		"chat scale": 2
	}
}

func _ready():

	var english_translation = Translation.new()
	english_translation.set_locale("en")
	
	english_translation.add_message("MESSAGE", "Message")
	english_translation.add_message("SEND", "Send")
	english_translation.add_message("SETTINGS", "Settings")
	english_translation.add_message("EXIT", "Exit")
	
	english_translation.add_message("MODEL", "Model")
	english_translation.add_message("SERVER", "Server")
	english_translation.add_message("Interface", "Interface")
	english_translation.add_message("LANGUAGE", "Language")
	english_translation.add_message("HORIZONTAL", "Horizontal Movement")
	english_translation.add_message("VERTICAL", "Vertical Movement")
	english_translation.add_message("TIMER", "Timer (time in seconds)")
	english_translation.add_message("RESOLUTION", "Resolution")
	english_translation.add_message("SCALE", "Chat scale")
	english_translation.add_message("SAVE", "Save")
	
	TranslationServer.add_translation(english_translation)

	var spanish_translation = Translation.new()
	spanish_translation.set_locale("es")
	
	spanish_translation.add_message("MESSAGE", "Mensaje")
	spanish_translation.add_message("SEND", "Enviar")
	spanish_translation.add_message("SETTINGS", "Opciones")
	spanish_translation.add_message("EXIT", "Salir")
	
	spanish_translation.add_message("MODEL", "Modelo")
	spanish_translation.add_message("SERVER", "Servidor")
	spanish_translation.add_message("Interface", "Interfaz")
	spanish_translation.add_message("LANGUAGE", "Idioma")
	spanish_translation.add_message("HORIZONTAL", "Movimiento Horizontal")
	spanish_translation.add_message("VERTICAL", "Movimiento Vertical")
	spanish_translation.add_message("TIMER", "Temporizador(Segundos)")
	spanish_translation.add_message("RESOLUTION", "Resolución")
	spanish_translation.add_message("SCALE", "Escala del chat")
	spanish_translation.add_message("SAVE", "Guardar")
	
	TranslationServer.add_translation(spanish_translation)


func save_config():
	for category in settings.keys():
		for key in settings[category].keys():
			config.set_value(category, key, settings[category][key])
	config.save(config_file_path)
	TranslationServer.set_locale(settings["interface"]["language"])
	DisplayServer.window_set_size(settings["interface"]["resolution"])


func load_config():
	if config.load(config_file_path) == OK:
		for category in settings.keys():
			if config.has_section(category):
				for key in settings[category].keys():
					settings[category][key] = config.get_value(category, key, settings[category][key])
		TranslationServer.set_locale(settings["interface"]["language"])
		DisplayServer.window_set_size(settings["interface"]["resolution"])
		
	else:
		save_config()
