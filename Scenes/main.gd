extends Node2D

var dragging:bool = false
var moving:bool = false
var direction:String = "right"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.load_config()
	$Timer.wait_time = Global.settings["interface"]["timer"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if moving and Global.settings["interface"]["horizontal movement"]:
		move_window()


func _input(event):
	if event is InputEventMouseMotion and dragging:
		get_tree().root.position = DisplayServer.mouse_get_position() - (DisplayServer.window_get_size()/2)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.double_click:
				$PopupMenu.set_position(DisplayServer.mouse_get_position()+Vector2i(DisplayServer.window_get_size().x/2,0))
				$PopupMenu.show()
				$Llama.play("eat_"+direction)
			elif event.pressed:
				dragging = true
				moving = false
			else:
				dragging = false
				if not $ChatWindow.visible and not $PopupMenu.visible:
					$Timer.start()
	
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			chat()

func chat():

	$Llama.play("eat_"+direction)
	if not $ChatWindow.visible:
		moving = false
		$Timer.stop()
	
		var monitor_id = DisplayServer.window_get_current_screen()
		var monitor_resolution = DisplayServer.screen_get_size(monitor_id)
		var window_position = DisplayServer.window_get_position()
		
		$ChatWindow.show()
		$ChatWindow.size = Vector2(DisplayServer.window_get_size()*2) 
		if window_position.x >= monitor_resolution.x/2:
			$ChatWindow.position = Vector2(window_position.x - DisplayServer.window_get_size().x*2 , window_position.y)
		else:
			$ChatWindow.position = Vector2(window_position.x + DisplayServer.window_get_size().x , window_position.y)
		
	else:
		$ChatWindow.hide()
		$Timer.start()


func move_window():
	var monitor_id = DisplayServer.window_get_current_screen()
	var monitor_resolution = DisplayServer.screen_get_size(monitor_id)
	var window_position = DisplayServer.window_get_position()

	match direction:

		"right":
			$Llama.play("walk_"+direction)
			if dragging == false and window_position.x < monitor_resolution.x-DisplayServer.window_get_size().x:
				get_tree().root.position += Vector2i(1,0)

			if window_position.x+DisplayServer.window_get_size().x >= monitor_resolution.x:
				$Llama.play("eat_"+direction)
				direction = "left"
				moving = false
				$Timer.start()

		"left":
			$Llama.play("walk_"+direction)
			if dragging == false and window_position.x > 0:
				get_tree().root.position -= Vector2i(1,0)

			if window_position.x == 0:
				$Llama.play("eat_"+direction)
				direction = "right"
				moving = false
				$Timer.start()


func _on_timer_timeout():
	moving = true
	if not Global.settings["interface"]["horizontal movement"]:
		$Llama.play("eat_"+direction)

func _on_popup_menu_id_pressed(id):
	match id:
		1:
			settings()
		2:
			get_tree().quit()

func _on_popup_menu_visibility_changed():
	if not $ChatWindow.visible and not $PopupMenu.visible and $Timer.is_stopped() and dragging == false:
		$Timer.start()
	else:
		$Timer.stop()

func settings():
	$SettingsWindow.show()


func _on_settings_window_close_requested():
	$SettingsWindow.hide()
