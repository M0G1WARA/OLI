extends Control

var url: String = "http://127.0.0.1:11434/api/generate"
var headersPOST = ["Content-Type: application/json"]
var data_to_send: String
var data = {
		"model": "deepseek-r1:8b",
		"prompt": "Hola"
	}
var pensamiento:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_enviar_pressed():
	var json = JSON.stringify(data)
	$HTTPRequest.request(url, headersPOST, HTTPClient.METHOD_POST, json)


func _on_http_request_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var lines = response_text.split("\n")
		
		var json = JSON.new()
		
		
		for line in lines:
			if line.strip_edges() != "":
				var json_result = json.parse(line)
				if json_result == OK:
					var data_received = json.data
					
					if data_received.response=='<think>':
						pensamiento = true
					
					if pensamiento:
						$VBoxContainer/Pensamiento.text += data_received.response
					else:
						$VBoxContainer/Respuesta.text += data_received.response
						
					if data_received.response=='</think>':
						pensamiento = false
					
				else:
					print("JSON Parse Error: ")
				
	else:
		print("Error en la respuesta: ", response_code)


func _on_mensaje_text_changed():
	data["prompt"] = $VBoxContainer/Mensaje.text
