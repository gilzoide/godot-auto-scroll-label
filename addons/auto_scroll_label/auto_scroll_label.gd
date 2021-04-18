tool
extends Control

export(String, MULTILINE) var text: String setget set_text
export(int, "Top", "Center", "Bottom", "Fill") var valign setget set_valign
export(bool) var autoscroll = true setget set_autoscroll
export(float) var speed = 32.0
export(float) var distance_to_repeat = 32.0 setget set_distance_to_repeat

var _animating = false
var _label = Label.new()
var _repeat_label = Label.new()
var _current_x = 0


func _ready() -> void:
	add_child(_label)
	_label.add_child(_repeat_label)
	_label.valign = valign
	_repeat_label.valign = valign
	_label.set_anchors_and_margins_preset(Control.PRESET_LEFT_WIDE, Control.PRESET_MODE_KEEP_WIDTH)
	_repeat_label.set_anchors_and_margins_preset(Control.PRESET_LEFT_WIDE, Control.PRESET_MODE_KEEP_WIDTH)
	_reposition()
	if not autoscroll:
		set_process(false)
	else:
		_check_if_should_scroll()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_check_if_should_scroll()


func _process(delta: float) -> void:
	_current_x += delta * speed
	if _current_x >= _label.get_minimum_size().x + distance_to_repeat:
		_current_x = fmod(_current_x, _label.get_minimum_size().x + distance_to_repeat)
	_label.rect_position = Vector2(-_current_x, 0)


func _get_minimum_size() -> Vector2:
	return Vector2(1, _label.get_minimum_size().y)


func set_animating(value: bool) -> void:
	if value:
		play()
	else:
		stop()


func play() -> void:
	_animating = true
	_repeat_label.visible = true
	set_process(true)


func stop() -> void:
	_animating = false
	_current_x = 0
	_label.rect_position = Vector2.ZERO
	_repeat_label.visible = false
	set_process(false)


func set_text(value: String) -> void:
	text = value
	if _label:
		_label.text = value
	if _repeat_label:
		_repeat_label.text = value
	_reposition()
	_check_if_should_scroll()


func set_valign(value: int) -> void:
	valign = value
	if _label:
		_label.valign = value
	if _repeat_label:
		_repeat_label.valign = value


func set_autoscroll(value: bool) -> void:
	autoscroll = value
	if is_inside_tree():
		_check_if_should_scroll()


func set_distance_to_repeat(value: float) -> void:
	distance_to_repeat = value
	_reposition()


func _check_if_should_scroll() -> void:
	if autoscroll and _label.get_minimum_size().x > rect_size.x:
		play()
	else:
		stop()


func _reposition() -> void:
	_repeat_label.rect_position = Vector2(_label.get_minimum_size().x + distance_to_repeat, 0)
