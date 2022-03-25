extends Control

signal buy_request(item)
signal ui_changed(state)

func _on_Shop_ui_changed(state) -> void:
	match(state):
		true, 1:	
			show()
			emit_signal("ui_changed", true)
		false, 0:
			hide()
			emit_signal("ui_changed", false)
	
	
## BUTTONS	
	
func _on_2x_pressed() -> void:
	emit_signal("buy_request", "x2")

func _on_4x_pressed() -> void:
	emit_signal("buy_request", "x4")

func _on_6x_pressed() -> void:
	emit_signal("buy_request", "x6")

func _on_125_pressed() -> void:
	emit_signal("buy_request", "125HP")

func _on_150_pressed() -> void:
	emit_signal("buy_request", "150HP")
	
func _on_200_pressed() -> void:
	emit_signal("buy_request", "200HP")

func _on_DoubleJ_pressed() -> void:
	emit_signal("buy_request", "DoubleJump")
	
func _on_Sit1_pressed() -> void:
	emit_signal("buy_request", "Sit1")
	
func _on_Sit2_pressed() -> void:
	emit_signal("buy_request", "Sit2")


func _on_Sit3_pressed() -> void:
	emit_signal("buy_request", "Sit3")
	
func _on_Zrusit_pressed() -> void:
	hide()
	emit_signal("ui_changed", false)






