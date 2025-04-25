extends Control

func _process(delta: float) -> void:
	$Timer.text = "Current Time: " + str(round_place(get_parent().get_parent().kart.timer,3))
	$BestTime.text = "Best Time: " + str(round_place(get_parent().get_parent().kart.bestTime,3))
	
	$TireCondition.text = "Tire Condition: " + str(roundi(get_parent().get_parent().kart.tireCondition*1000))
	$TireType.text = "Tire Type: " + str(get_parent().get_parent().kart.tireType)
	$BatteryDisplay.text = "Battery: " + str(roundi(get_parent().get_parent().kart.battery)) + "%"
	
	if get_parent().get_parent().kart.inPit:
		$"Pit Condition".text = "In Pit\n(Use left and right arrows to switch tires)"
	else:
		$"Pit Condition".text = "Out Of Pit"


func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
