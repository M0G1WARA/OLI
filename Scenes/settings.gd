extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$TabContainer/Ollama/HTTPRequest.request("http://127.0.0.1:11434/api/tags")


func _on_http_request_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	if error == OK:
		var data_received = json.data
		var models = data_received["models"] 
		var item_list = $TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList
		item_list.clear()

		for model in models:
			item_list.add_item(model["name"])
		
		load_config()
	else:
		print("Error al parsear JSON: ", json.error_string)

func load_config():
	$TabContainer/Ollama/MarginContainer/VBoxContainer/ServerEdit.text = Global.settings["ollama"]["server"]
	for i in range($TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList.get_item_count()):
		if $TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList.get_item_text(i) == Global.settings["ollama"]["model"]:
			$TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList.select(i)
			break
	
	for i in range($TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.get_item_count()):
		if $TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.get_item_text(i) == Global.settings["interface"]["language"]:
			$TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.select(i)
			break
	$TabContainer/Interface/MarginContainer/VBoxContainer/CheckButton.button_pressed = Global.settings["interface"]["horizontal movement"]
	$TabContainer/Interface/MarginContainer/VBoxContainer/SpinBox.value = Global.settings["interface"]["timer"]
	


func _on_save_button_pressed():
	Global.settings["ollama"]["model"] = $TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList.get_item_text($TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList.get_selected_items()[0])if $TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList.get_selected_items().size() > 0 else ""
	Global.settings["ollama"]["server"] = $TabContainer/Ollama/MarginContainer/VBoxContainer/ServerEdit.text
	Global.save_config()


func _on_save_interface_button_pressed():
	Global.settings["interface"]["language"] = $TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.get_item_text($TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.get_selected_items()[0])
	Global.settings["interface"]["horizontal movement"] = $TabContainer/Interface/MarginContainer/VBoxContainer/CheckButton.button_pressed
	Global.settings["interface"]["timer"] = $TabContainer/Interface/MarginContainer/VBoxContainer/SpinBox.value
	Global.save_config()
