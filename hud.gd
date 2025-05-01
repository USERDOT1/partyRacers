extends Control
var spending = "balanced"

func _process(delta: float) -> void:
	#print(spending)
	if spending == "Ultra Recharge":
		$Lights.animation = "UltraRecharge"
	elif spending == "Big Recharge":
		$Lights.animation = "BigRecharge"
	elif spending == "Recharge":
		$Lights.animation = "Recharge"
	elif spending == "Balanced":
		$Lights.animation = "Balanced"
	elif spending == "Spend":
		$Lights.animation = "Spend"
	elif spending == "Big Spend":
		$Lights.animation = "BigSpend"
	elif spending == "Ultra Spend":
		$Lights.animation = "UltraSpend"
	$Timer.text = "Current Time: " + str(round_place(get_parent().get_parent().kart.timer,3))
	$BestTime.text = "Best Time: " + str(round_place(get_parent().get_parent().kart.bestTime,3))
	
	#Instead of using a if statement used this cool thing that speaks for itself
	$ResetText.visible = get_parent().get_parent().kart.flipped
		
	
	
	
	
	$Laps.text = "Lap " + str(get_parent().get_parent().kart.laps) + "/" + str(get_parent().get_parent().maxLaps)
	
	$TireCondition.text = "Tire Condition: " + str(roundi(get_parent().get_parent().kart.tireCondition*1000))
	$TireType.text = "Tire Type: " + str(get_parent().get_parent().kart.tireType)
	$BatteryDisplay.text = "Battery: " + str(roundi(get_parent().get_parent().kart.battery*100/get_parent().get_parent().kart.maxBattery)) + "%"
	
	if get_parent().get_parent().kart.inPit:
		$"Pit Condition".text = "In Pit\n(Use left and right arrows to switch tires)"
	else:
		$"Pit Condition".text = "Out Of Pit"


func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
