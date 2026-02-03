class_name InputController extends Node

@export var controller_type : ControllerType

var direction := Vector2.ZERO
signal shoot

enum ControllerType {
	PLAYER_1,
	PLAYER_2,
	COMPUTER_EASY,
	COMPUTER_MEDIUM,
	COMPUTER_HARD,
}
