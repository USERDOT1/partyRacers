extends Control
var spending = "balanced"

func _process(delta: float) -> void:
	#print(spending)
	if spending == "Ultra Recharge":
		$Lights.animation = "Recharge2"
	elif spending == "Big Recharge":
		$Lights.animation = "Recharge1"
	elif spending == "Recharge":
		$Lights.animation = "Recharge1"
	elif spending == "Balanced":
		$Lights.animation = "Balanced"
	elif spending == "Spend":
		$Lights.animation = "Spend1"
	elif spending == "Big Spend":
		$Lights.animation = "Spend1"
	elif spending == "Ultra Spend":
		$Lights.animation = "Spend2"
	$Timer.text = "Current Time: " + str(round_place(get_parent().get_parent().kart.timer,3))
	$BestTime.text = "Best Time: " + str(round_place(get_parent().get_parent().kart.bestTime,3))
	
	$TireCondition.text = "Tire Condition: " + str(roundi(get_parent().get_parent().kart.tireCondition*1000))
	$TireType.text = "Tire Type: " + str(get_parent().get_parent().kart.tireType)
	$BatteryDisplay.text = "Battery: " + str(roundi(get_parent().get_parent().kart.battery*100/get_parent().get_parent().kart.maxBattery)) + "%"
	
	if get_parent().get_parent().kart.inPit:
		$"Pit Condition".text = "In Pit\n(Use left and right arrows to switch tires)"
	else:
		$"Pit Condition".text = "Out Of Pit"


func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
