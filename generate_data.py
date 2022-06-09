from random import choice


def choose_data():
	years = [2021, 2022]
	months = [i for i in range(1, 13)]
	days = [i for i in range(1, 28)]
	return "'" + str(choice(years)) + '-' + str(choice(months)) + '-' + str(choice(days)) + "'"


def choose_hour():
	hours = [i for i in range(10, 23)]
	minutes = [0, 15, 30, 45]
	return "'" + str(choice(hours)) + ':' + str(choice(minutes)) + "'"


def choose_moderate():
	return str(choice(['true', 'false']))


def choose_duration():
	hours = [i for i in range(0, 5)]
	minutes = [0, 15, 30, 45]
	return "'" + str(choice(hours)) + ' hours ' + str(choice(minutes)) + ' minutes' + "'"


def choose_dices():
	return str(choice([1, 2, 3]))


def choose_max_teams():
	return str(choice([i for i in range(2, 11)]))


def generate_matches():
	n = 0
	format = 0
	for i in range(0, 100):
		for j in range(0, 100):
			if format == 2:
				print("")
				format = 0
			else:
				print(" ", end="")
			print("(" + str(n) + ", " + choose_data() + ", " + choose_hour() + ", " + choose_moderate() + ", " + choose_duration() + ", " + choose_max_teams() + ", " + str(i) + "),", end="")
			n += 1
			format += 1
	print("\n")


def generate_games():
	format = 0
	for i in range(0, 100):
		if format == 10:
			print("")
			format = 0
		else:
			print(" ", end="")
		print("(" + str(i) + ", " + choose_dices() + "),", end="")
		format += 1
	print("\n")
		


generate_games()
generate_matches()
