class_name FlagMarker extends Marker2D

func _ready() -> void:
	Global.level_change.connect(_on_level_change)
	
func _on_level_change(_level: int) -> void:
	if Global.get_level_rect().has_point(position):
		Global.computer_target = self
