extends Control

func _process(delta: float) -> void:
	$Timer.text = "Current Time: " + str(round_place(get_parent().get_parent().kart.timer,3))
	$BestTime.text = "Best Time: " + str(round_place(get_parent().get_parent().kart.bestTime,3))
	
	$TireCondition.text = "Tire Condition: " + str(roundi(get_parent().get_parent().kart.tireCondition*1000))
	$TireType.text = "Tire Type: " + str(get_parent().get_parent().kart.tireType)
	$BatteryDisplay.text = "Battery: " + str(roundi(get_parent().get_parent().kart.battery)) + "%"
	
	


func _on_pitstop_pressed() -> void:
	if $TireTypeSelect.selected == 0:
		get_parent().get_parent().kart.tireType = "Soft"
		get_parent().get_parent().kart.tireCondition = 2.0
	elif $TireTypeSelect.selected == 1:
		get_parent().get_parent().kart.tireType = "Medium"
		get_parent().get_parent().kart.tireCondition = 1.2
	elif $TireTypeSelect.selected == 2:
		get_parent().get_parent().kart.tireType = "Hard"
		get_parent().get_parent().kart.tireCondition = 0.8
	
func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
