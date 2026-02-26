extends Node

signal credits_changed(new_amount: int)

var credits: int = 10: # todo figure out starting cash
	set(value):
		credits = value
		credits_changed.emit(credits)

func add_credits(amount: int) -> void:
	credits += amount

func spend_credits(amount: int) -> bool:
	if (amount > credits):
		return false
	credits -= amount
	return true
