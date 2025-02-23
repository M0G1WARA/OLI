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
	
	$TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.select( 0 if Global.settings["interface"]["language"] == "en" else 1)
	
	for i in range($TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.get_item_count()):
		if $TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.get_item_text(i) == Global.settings["interface"]["language"]:
			$TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.select(i)
			break
	$TabContainer/Interface/MarginContainer/VBoxContainer/CheckButtonHorizontal.button_pressed = Global.settings["interface"]["horizontal movement"]
	$TabContainer/Interface/MarginContainer/VBoxContainer/CheckButtonVertical.button_pressed = Global.settings["interface"]["vertical movement"]
	$TabContainer/Interface/MarginContainer/VBoxContainer/SpinBox.value = Global.settings["interface"]["timer"]
	
	var resolution = Global.settings["interface"]["resolution"].x
	$TabContainer/Interface/MarginContainer/VBoxContainer/HBoxContainer/Resolution.text = str(resolution) +" x "+ str(resolution)
	$TabContainer/Interface/MarginContainer/VBoxContainer/ResolutionHSlider.value = resolution
	
	var scale = Global.settings["interface"]["chat scale"]
	$TabContainer/Interface/MarginContainer/VBoxContainer/HBoxContainer2/Scale.text = str(scale)+" ("+str(scale*resolution)+" x "+str(scale*resolution)+")" 
	$TabContainer/Interface/MarginContainer/VBoxContainer/ScaleHSlider.value = Global.settings["interface"]["chat scale"]
	


func _on_save_button_pressed():
	Global.settings["ollama"]["model"] = $TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList.get_item_text($TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList.get_selected_items()[0])if $TabContainer/Ollama/MarginContainer/VBoxContainer/ItemList.get_selected_items().size() > 0 else ""
	Global.settings["ollama"]["server"] = $TabContainer/Ollama/MarginContainer/VBoxContainer/ServerEdit.text
	Global.save_config()


func _on_save_interface_button_pressed():
	Global.settings["interface"]["language"] = "en" if $TabContainer/Interface/MarginContainer/VBoxContainer/ItemList.get_selected_items()[0] == 0 else "es"
	Global.settings["interface"]["horizontal movement"] = $TabContainer/Interface/MarginContainer/VBoxContainer/CheckButtonHorizontal.button_pressed
	Global.settings["interface"]["vertical movement"] = $TabContainer/Interface/MarginContainer/VBoxContainer/CheckButtonVertical.button_pressed
	Global.settings["interface"]["timer"] = $TabContainer/Interface/MarginContainer/VBoxContainer/SpinBox.value
	var tmpResolution = $TabContainer/Interface/MarginContainer/VBoxContainer/ResolutionHSlider.value
	Global.settings["interface"]["resolution"] = Vector2i(tmpResolution,tmpResolution)
	Global.settings["interface"]["chat scale"] = $TabContainer/Interface/MarginContainer/VBoxContainer/ScaleHSlider.value
	Global.save_config()


func _on_resolution_h_slider_value_changed(value):
	var tmpScale = $TabContainer/Interface/MarginContainer/VBoxContainer/ScaleHSlider.value
	$TabContainer/Interface/MarginContainer/VBoxContainer/ScaleHSlider.emit_signal("value_changed",tmpScale)
	var tmpResolution = str($TabContainer/Interface/MarginContainer/VBoxContainer/ResolutionHSlider.value)
	$TabContainer/Interface/MarginContainer/VBoxContainer/HBoxContainer/Resolution.text = tmpResolution +" x "+ tmpResolution


func _on_scale_h_slider_value_changed(value):
	var tmpResolution = $TabContainer/Interface/MarginContainer/VBoxContainer/ResolutionHSlider.value
	var tmpScale = $TabContainer/Interface/MarginContainer/VBoxContainer/ScaleHSlider.value
	$TabContainer/Interface/MarginContainer/VBoxContainer/HBoxContainer2/Scale.text = str(tmpScale)+" ("+str(tmpScale*tmpResolution)+" x "+str(tmpScale*tmpResolution)+")" 
