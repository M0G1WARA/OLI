extends Control

var url: String = "api/generate"
var headersPOST = ["Content-Type: application/json"]
var data = {
		"model": "",
		"prompt": ""
	}
var think:bool = false


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
						think = true
					
					if think:
						$VBoxContainer/Think.text += data_received.response
					else:
						$VBoxContainer/Response.text += data_received.response
						
					if data_received.response=='</think>':
						think = false
					
				else:
					$AcceptDialog.dialog_text = "ERROR JSON"
					$AcceptDialog.show()
				
	else:
		$AcceptDialog.dialog_text = "ERROR RESPONSE" + response_code
		$AcceptDialog.show()
	
	$VBoxContainer/SendButton.disabled = false
	$VBoxContainer/SendButton/ProgressBar.hide()

func _on_prompt_text_changed():
	data["prompt"] = $VBoxContainer/Prompt.text


func _on_send_button_pressed():
	if Global.settings["ollama"]["model"] != "":
		$VBoxContainer/SendButton.disabled = true
		$VBoxContainer/SendButton/ProgressBar.show()
		data["model"] = Global.settings["ollama"]["model"]
		$VBoxContainer/Response.clear()
		var json = JSON.stringify(data)
		$HTTPRequest.request(Global.settings["ollama"]["server"]+url, headersPOST, HTTPClient.METHOD_POST, json)
	else:
		$AcceptDialog.dialog_text = "ERROR MODEL"
		$AcceptDialog.show()
	
