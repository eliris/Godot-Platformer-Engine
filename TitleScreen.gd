extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/TextureRect/VBoxContainer/TextureButton.grab_focus()
	
	

func _physics_process(delta):
	if $MarginContainer/VBoxContainer/TextureRect/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureRect/VBoxContainer/TextureButton.grab_focus()
	
	if $MarginContainer/VBoxContainer/TextureRect/VBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureRect/VBoxContainer/TextureButton2.grab_focus()


func _on_TextureButton_pressed():
	get_tree().change_scene("res://StageOne.tscn")


func _on_TextureButton2_pressed():
	get_tree().quit()# Replace with function body.
