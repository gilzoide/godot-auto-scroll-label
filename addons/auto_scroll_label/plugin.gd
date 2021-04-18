tool
extends EditorPlugin

const AutoScrollLabel = preload("res://addons/auto_scroll_label/auto_scroll_label.gd")


func _enter_tree() -> void:
	add_custom_type("AutoScrollLabel", "Control", AutoScrollLabel, null)


func _exit_tree() -> void:
	remove_custom_type("AutoScrollLabel")
