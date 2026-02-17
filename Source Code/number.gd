extends Node2D


const HIGHEST_OKTAL_NUM: int = 077_777

var one_digit_nums: Array[String] = ["kew", "'aw", "mune", "pxey", "tsìng", "mrr", "pukap", "kinä"]
var preffixes_for_nums: Array[String] = ["", "", "me", "pxe", "tsì", "mrr", "pu", "ki"]
var suffixes_for_nums: Array[String] = ["", "aw", "mun", "pey", "sìng", "mrr", "fu", "hin"]
var eight_power_x: Array[String] = ["", "vo", "za", "voza", "zaza"]
var eight_power_x_with_ending: Array[String] = ["", "vol", "zam", "vozam", "zazam"]


func deci2octal(num_as_str: String) -> String:
	var result: String = ""
	var provisional: int = int(num_as_str)
	
	if ( float(provisional) / 8 ) < 1:
		result = str(provisional)
	else:
		while true:
			result = str(provisional % 8) + result
			provisional = int( float(provisional) / 8 )
			
			if float(provisional) / 8 < 1:
				result = str(provisional % 8) + result
				break
	
	return "0" + result


func octal2deci(octal_num: String) -> String:
	var result: int = 0
	var power: int = 0
	
	for i: String in octal_num.reverse():
		result += int(i) * 8 ** power
		power += 1
	
	return str(result)


func octal(num_as_str: String) -> String:
	var result: String = num_as_str
	
	if is_octal(num_as_str) == false:
		result = "0" + num_as_str
	
	return result


func deci(num_as_str: String) -> String:
	var result: String = num_as_str
	
	if is_octal(num_as_str) == true:
		result = str(int(num_as_str))
	
	return result


func is_octal(num_as_str: String) -> bool:
	var result: bool = false
	
	if num_as_str.length() > 1 and num_as_str[0] == "0":
		result = true
	
	return result


func octal_num_in_text(octal_num: String) -> String:
	var result: String = ""
	
	if octal_num.length() == 2:
		result = one_digit_nums[int(octal_num[1])]
	elif int(octal_num) > HIGHEST_OKTAL_NUM:
		result = "Es gibt noch keine Namen für Oktalzahlen\nin Na'vi, die höher sind als die 077.777!"
	else:
		var is_the_first_digit_from_behind_a_zero: bool = false
		var is_the_first_digit_from_behind_a_one: bool = false
		
		if octal_num.reverse()[0] == "0":
			is_the_first_digit_from_behind_a_zero = true
		
		if octal_num.reverse()[0] == "1":
			is_the_first_digit_from_behind_a_one = true
		
		for i: int in (octal_num.length() - 1):
			if i == 0 and is_the_first_digit_from_behind_a_zero == false:
				result = suffixes_for_nums[int(octal_num.reverse()[i])]
			else:
				if octal_num.reverse()[i] != "0":
					if is_the_first_digit_from_behind_a_zero == true:
						result = preffixes_for_nums[int(octal_num.reverse()[i])] + eight_power_x_with_ending[i] + result
						is_the_first_digit_from_behind_a_zero = false
					elif is_the_first_digit_from_behind_a_one == true:
						result = preffixes_for_nums[int(octal_num.reverse()[i])] + eight_power_x_with_ending[i] + result
						is_the_first_digit_from_behind_a_one = false
					else:
						result = preffixes_for_nums[int(octal_num.reverse()[i])] + eight_power_x[i] + result
		
	return result


func add_decimal_points(num_as_str: String) -> String:
	var result: String = ""
	
	if is_octal(num_as_str) == false:
		for i: int in num_as_str.length():
			if i != 0 and i % 3 == 0 and i < num_as_str.length():
				result = num_as_str.reverse()[i] + "." + result
			else:
				result = num_as_str.reverse()[i] + result
	else:
		var provisional: String = str(int(num_as_str))
		for i: int in provisional.length():
			if i != 0 and i % 3 == 0 and i < num_as_str.length():
				result = num_as_str.reverse()[i] + "." + result
			else:
				result = num_as_str.reverse()[i] + result
		result = "0" + result
	
	return result


func display_syllables(syllables_arr: Array[String]) -> String:
	var result: String = ""
	
	for i: int in syllables_arr.size():
		result += syllables_arr[i]
		
		if (syllables_arr.size() - 1) - i != 0:
			result += "."
	
	return result
func _separate_all_syllables(num_as_text: String) -> Array[String]:
	var result: Array[String] = []
	var vowels: Array[String] = ["a", "e", "i", "o", "u", "ä", "ì", "r"]
	var new_syllable: String = ""
	var r_found: bool = false
	
	for i: int in num_as_text.length():
		if r_found == true:
			r_found = false
			continue
		
		var it_is_a_vowel: bool = false
		
		for vowel: String in vowels:
			if num_as_text[i] == vowel:
				if num_as_text[i] == "r":
					new_syllable += "rr"
					r_found = true
					result.push_back(new_syllable)
					new_syllable = ""
					it_is_a_vowel = true
					break
				else:
					new_syllable += num_as_text[i]
					result.push_back(new_syllable)
					new_syllable = ""
					it_is_a_vowel = true
					break
		
		if it_is_a_vowel == false:
			new_syllable += num_as_text[i]
	
	result[result.size() - 1] += new_syllable
	
	return result
func find_emphasis(num_as_text: String) -> Array[String]:
	var result: Array[String] = _separate_all_syllables(num_as_text)
	var exceptions: Array[String] = ["vol", "vo", "za", "zam"]
	var emphasis_found: bool = false
	
	result.reverse()
	
	for i: int in result.size():
		var it_is_an_exception: bool = false
		
		if emphasis_found == false:
			for exception: String in exceptions:
				if result[i] == exception:
					if exception == "vol" or exception == "zam":
						if result.size() == 1:
							result[i] = result[i].to_upper()
							it_is_an_exception = true
							emphasis_found = true
							break
						else:
							it_is_an_exception = true
							break
					else:
						if (result.size() - 1) - i == 0:
							result[i] = result[i].to_upper()
							it_is_an_exception = true
							emphasis_found = true
							break
						else:
							it_is_an_exception = true
							break
		else:
			break
		
		if it_is_an_exception == false:
			result[i] = result[i].to_upper()
			break
	
	result.reverse()
	
	return result
