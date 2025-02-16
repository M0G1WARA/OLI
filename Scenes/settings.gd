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
	else:
		print("Error al parsear JSON: ", json.error_string)
