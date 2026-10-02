extends PanelContainer
class_name THint
@onready var label : Label = $MarginContainer/HBoxContainer/Label

func update_content(content:String):
	label.text = content
