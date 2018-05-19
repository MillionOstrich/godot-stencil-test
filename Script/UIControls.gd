extends Node

func _input(event):
	if event is InputEventKey and not event.is_echo() and event.is_pressed():
		if event.get_scancode() == KEY_H:
			self.set_visible(not self.is_visible())
		if event.get_scancode() == KEY_ESCAPE:
			self.get_tree().quit()
