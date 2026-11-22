class_name Utils
extends Node


static func format_number(value: float) -> String:
	var number = str(int(value))
	var result = ""
	
	for i in range(number.length()):
		if i > 0 and (number.length() - i) % 3 == 0:
			result += ","
		result += number[i]
	
	return result


static func format_number_two_decimals(value: float) -> String:
	var parts = ("%.2f" % value).split(".")
	var number = parts[0]
	var result = ""
	
	for i in range(number.length()):
		if i > 0 and (number.length() - i) % 3 == 0:
			result += ","
		result += number[i]
	
	return result + "." + parts[1]
