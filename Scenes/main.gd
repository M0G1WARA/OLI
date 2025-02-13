extends Node2D

var dragging:bool = false
var chat_window:bool = false
var moving:bool = false
var direction:String = "left"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if moving:
		move_window()


func _input(event):
	if event is InputEventMouseMotion and dragging:
		get_tree().root.position = DisplayServer.mouse_get_position() - (DisplayServer.window_get_size()/2)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true
			moving = false
		else:
			dragging = false
			if not chat_window:
				$Timer.start()
	
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			chat()

func chat():
	
	if not chat_window:
		chat_window = true
		moving = false
		$Timer.stop()
	
		var monitor_id = DisplayServer.window_get_current_screen()
		var monitor_resolution = DisplayServer.screen_get_size(monitor_id)
		var window_position = DisplayServer.window_get_position()
		
		var chat_scene = load("res://Scenes/chat.tscn")
		var instance = chat_scene.instantiate()
		var new_window = Window.new()
		new_window.borderless = true
		new_window.transparent = true
		new_window.always_on_top = true
		new_window.title = "Chat"
		new_window.size = Vector2(DisplayServer.window_get_size()*2) 
		if window_position.x >= monitor_resolution.x/2:
			new_window.position = Vector2(window_position.x - DisplayServer.window_get_size().x*2 , window_position.y)
		else:
			new_window.position = Vector2(window_position.x + DisplayServer.window_get_size().x , window_position.y)
		new_window.add_child(instance) 
		new_window.show()
		add_child(new_window)
		
	else:
		for child in get_children():
			if child is Window:
				child.queue_free()
				break
		chat_window = false
		$Timer.start()


func move_window():
	var monitor_id = DisplayServer.window_get_current_screen()
	var monitor_resolution = DisplayServer.screen_get_size(monitor_id)
	var window_position = DisplayServer.window_get_position()

	match direction:

		"left":
			if dragging == false and window_position.x < monitor_resolution.x-DisplayServer.window_get_size().x:
				get_tree().root.position += Vector2i(1,0)

			if window_position.x+DisplayServer.window_get_size().x >= monitor_resolution.x:
				direction = "right"
				moving = false
				$Timer.start()

		"right":
			if dragging == false and window_position.x > 0:
				get_tree().root.position -= Vector2i(1,0)

			if window_position.x == 0:
				direction = "left"
				moving = false
				$Timer.start()


func _on_timer_timeout():
	moving = true
