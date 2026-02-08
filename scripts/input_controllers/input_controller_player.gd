class_name InputControllerPlayer extends InputController

var _player_type : String

func _ready() -> void:
	match controller_type:
		ControllerType.PLAYER_1:
			_player_type = "p1"
		ControllerType.PLAYER_2:
			_player_type = "p2"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("%s_shoot" % _player_type):
		shoot.emit()
	
	if Input.is_action_pressed("%s_up" % _player_type):
		print("up")
		direction = Vector2.UP

	elif Input.is_action_pressed("%s_down" % _player_type):
		print("down")
		
		direction = Vector2.DOWN

	elif Input.is_action_pressed("%s_left" % _player_type):
		direction = Vector2.LEFT

	elif Input.is_action_pressed("%s_right" % _player_type):
		direction = Vector2.RIGHT

	else:
		direction = Vector2.ZERO
