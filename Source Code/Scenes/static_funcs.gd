extends Node2D


class_name NumFuncs

const HIGHEST_OCTAL_NUM: int = 77_777

static var one_digit_nums: Array[String] = ["kew", "'aw", "mune", "pxey", "tsìng", "mrr", "pukap", "kinä"]
static var preffixes_for_nums: Array[String] = ["", "", "me", "pxe", "tsì", "mrr", "pu", "ki"]
static var suffixes_for_nums: Array[String] = ["", "aw", "mun", "pey", "sìng", "mrr", "fu", "hin"]
static var eight_power_x: Array[String] = ["", "vo", "za", "voza", "zaza"]
static var eight_power_x_with_ending: Array[String] = ["", "vol", "zam", "vozam", "zazam"]


static func octal_into_deci(octal_num: int) -> int:
	var result: int = 0
	var octal_num_as_str: String = str(octal_num).reverse()
	
	for i: int in str(octal_num).length():
		result += int(octal_num_as_str[i]) * 8 ** i
	
	return result


static func deci_into_octal(deci_num: int) -> int:
	var int_value:int = deci_num
	var result: String = ""
	
	while true:
		if int_value == 0:
			break
		else:
			result = str(int_value % 8) + result
			int_value = int( float(int_value) / 8 )
	
	return int(result)


static func add_commata(num: int) -> String:
	var result: String = ""
	var reversed_str: String = str(num).reverse()
	
	
	for i: int in reversed_str.length():
		if i % 3 == 0 and i != 0:
			result = reversed_str[i] + SessionManager.current_save.separation_sign + result
		else:
			result = reversed_str[i] + result
	
	return result


static func octal_num_into_text(octal_num: String) -> String:
	var result: String = ""
	
	if octal_num.length() == 1:
		result = one_digit_nums[int(octal_num[0])]
	elif int(octal_num) > HIGHEST_OCTAL_NUM:
		if SessionManager.current_save.language_selected == "English":
			result = "There is currently no name for\noctal numbers greater than " + SessionManager.current_save.octal_sign + "77" + SessionManager.current_save.separation_sign + "777"
		elif SessionManager.current_save.language_selected == "Deutsch":
			result = "Es gibt noch keine Namen für Oktalzahlen\nin Na'vi, die höher sind als die " + SessionManager.current_save.octal_sign + "77" + SessionManager.current_save.separation_sign + "777!"
	else:
		var is_the_first_digit_from_behind_a_zero: bool = false
		var is_the_first_digit_from_behind_a_one: bool = false
		
		if octal_num.reverse()[0] == "0":
			is_the_first_digit_from_behind_a_zero = true
		
		if octal_num.reverse()[0] == "1":
			is_the_first_digit_from_behind_a_one = true
		
		for i: int in octal_num.length():
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

static func display_syllables(syllables_arr: Array[String]) -> String:
	var result: String = ""
	
	for i: int in syllables_arr.size():
		result += syllables_arr[i]
		
		if (syllables_arr.size() - 1) - i != 0:
			result += "."
	
	return result
static func _separate_all_syllables(num_as_text: String) -> Array[String]:
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
static func find_emphasis(num_as_text: String, octal_num: int) -> Array[String]:
	var result: Array[String] = []
	var exceptions: Array[String] = ["vol", "vo", "za", "zam"]
	var emphasis_found: bool = false
	var nums_from_zero_to_seven: Array = [["KEW"], ["'AW"], ["MU", "ne"], ["PXEY"], ["TSÌNG"], ["MRR"], ["PU", "kap"], ["KI", "nä"]]
	
	if octal_num >= 0 and octal_num <= 7:
		for i: int in nums_from_zero_to_seven[octal_num].size():
			result.push_back(nums_from_zero_to_seven[octal_num][i])
	else:
		result = _separate_all_syllables(num_as_text)
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
