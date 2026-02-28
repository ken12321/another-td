extends Node

signal credits_changed(new_amount: int)
signal wave_changed(new_wave: int)

var credits: int = 1000: # todo figure out starting cash
	set(value):
		credits = value
		credits_changed.emit(credits)

var current_wave: int = 1:
	set(value):
		current_wave = value
		wave_changed.emit(current_wave)

func add_credits(amount: int) -> void:
	credits += amount

func spend_credits(amount: int) -> bool:
	if (amount > credits):
		return false
	credits -= amount
	return true
