from random import choice, randint


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


def choose_dices_minmax():
	min = choice([0, 1, 2, 3, 4, 5])
	max = choice([1, 2, 3, 4, 5, 6])
	if min > max:
		min, max = max, min
	if min == max:
		min -= 1
	return str(min), str(max)


def choose_max_teams():
	return str(choice([i for i in range(2, 11)]))


def choose_icon_set():
	return str(choice(["'mammiferi'", "'felini'", "'volatili'", "'pesci'", "'rettili'"]))


def choose_boxes(boxes, game_id):
	new_boxes_number = randint(20, 100)
	if new_boxes_number % 2 != 0:
		new_boxes_number += 1
	for i in range(0, new_boxes_number):
		box = {"game_id": game_id, "box_number": i, "box_type": "normal", "destination_num": -1, "quiz": -1, "task": -1}
		boxes.append(box)


def choose_stairs_snakes(boxes):
	lower_half = [i for i in range(1, len(boxes) // 2)]
	upper_half = [i for i in range((len(boxes) - 1) // 2, len(boxes) - 1)]
	special_boxes_num = randint(1, 3)
	for i in range(0, special_boxes_num):
		stair = 0
		snake = 0
		while (stair == snake):
			stair = choice(lower_half)
			snake = choice(upper_half)
		lower_half.remove(stair)
		upper_half.remove(snake)
		stair_dest = 0
		snake_dest = 0
		while (stair_dest == snake_dest):
			stair_dest = choice(upper_half)
			snake_dest = choice(lower_half)
		upper_half.remove(stair_dest)
		lower_half.remove(snake_dest)
		boxes[stair].update({"box_type": "stair", "destination_num": stair_dest})
		boxes[snake].update({"box_type": "snake", "destination_num": snake_dest})


def choose_quiz_task(boxes):
	quiz_number = randint(50, 100)
	task_number = randint(50, 100)
	boxes_index = [i for i in range(len(boxes))]
	choose_quiz = [i for i in range(0, 100)]
	choose_task = [i for i in range(0, 100)]
	for i in range(0, quiz_number):
		quiz_index = choice(boxes_index)
		if boxes[quiz_index]["box_type"] == "normal":
			chosen_quiz = choice(choose_quiz)
			choose_quiz.remove(chosen_quiz)
			boxes[quiz_index].update({"quiz": chosen_quiz})
	for i in range(0, task_number):
		task_index = choice(boxes_index)
		if boxes[task_index]["box_type"] == "normal":
			if boxes[task_index]["quiz"] == -1:
				chosen_task = choice(choose_task)
				choose_task.remove(chosen_task)
				boxes[task_index].update({"task": chosen_task})



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
			duration = choose_duration()
			print("(" + str(n) + ", " + choose_data() + ", " + choose_hour() + ", " + choose_moderate() + ", " + duration + ", " + duration + ", " + choose_max_teams() + ", " + str(i) + "),", end="")
			n += 1
			format += 1
	print("\n")


def generate_games():
	format = 0
	for i in range(0, 100):
		if format == 5:
			print("")
			format = 0
		else:
			print(" ", end="")
		min, max = choose_dices_minmax()
		print("(" + str(i) + ", " + choose_dices() + ", " + min + ", " + max + ", " + choose_icon_set() + "),", end="")
		format += 1
	print("\n")
		

def generate_boxes():
	boxes = []
	videos = ["video_1", "video_2", "video_3", "video_4", "video_5", "video_6", "video_7", "video_8", "video_9", "video_10"]
	for i in range(0, 100):
		game_boxes = []
		choose_boxes(game_boxes, i)
		choose_stairs_snakes(game_boxes)
		boxes = boxes + game_boxes
	choose_quiz_task(boxes)
	print("Normal boxes\n")
	format = 0
	for box in boxes:
		if format == 2:
			print("")
			format = 0
		else:
			print(" ", end="")
		game_id = box["game_id"]
		box_num = box["box_number"]
		quiz = box["quiz"]
		task = box["task"]
		if quiz != -1:
			print("(" + str(box_num) + ", " + str(game_id) + ", " + "100, 100, " + str(choice(["true", "false"])) + ", " + str(game_id) + ", " + "'" + str(choice(videos)) + "'" + ", NULL, " + str(quiz) + "),", end="")
		elif task != -1:
			print("(" + str(box_num) + ", " + str(game_id) + ", " + "100, 100, " + str(choice(["true", "false"])) + ", " + str(game_id) + ", " + "'" + str(choice(videos)) + "', " + str(task) + ", NULL" + "),", end="")
		else:
			print("(" + str(box_num) + ", " + str(game_id) + ", " + "100, 100, " + str(choice(["true", "false"])) + ", " + str(game_id) + ", " + "'" + str(choice(videos)) + "', NULL, NULL" + "),", end="")
		format += 1
	print("\n")
	print("Stair boxes\n")
	format = 0
	for box in boxes:
		if format == 5:
			print("")
			format = 0
		if box["box_type"] == "stair":
			print("(" + str(box["box_number"]) + ", " + str(box["game_id"]) + ", " + str(box["destination_num"]) + ", " + str(box["game_id"]) + "),", end=" ")
			format += 1
	print("\n")
	print("Snake boxes\n")
	format = 0
	for box in boxes:
		if format == 5:
			print("")
			format = 0
		if box["box_type"] == "snake":
			print("(" + str(box["box_number"]) + ", " + str(box["game_id"]) + ", " + str(box["destination_num"]) + ", " + str(box["game_id"]) + "),", end=" ")
			format += 1
	print("\n")



	


def generate_gameboard():
	format = 0
	wallpapers = ["sfondo_1", "sfondo_2", "sfondo_3", "sfondo_4", "sfondo_5", "sfondo_6", "sfondo_7", "sfondo_8", "sfondo_9", "sfondo_10"]
	for i in range(0, 100):
		if format == 5:
			print("")
			format = 0
		else:
			print(" ", end="")
		print("(" + str(i) + ", " + "'" + str(choice(wallpapers)) + "'" + "),", end="")
		format += 1
	print("\n")


def generate_quiz():
	format = 0
	imgs = ["img_1", "img_2", "img_3", "img_4", "img_5", "img_6", "img_7", "img_8", "img_9", "img_10"]
	max_time = ["1 minute", "45 seconds", "30 seconds", "15 seconds", "10 seconds"]
	for i in range(0, 100):
		if format == 3:
			print("")
			format = 0
		else:
			print(" ", end="")
		print("(" + str(i) + ", " + "'" + str("A quiz text") + "'" + ", " + "'" + str(choice(max_time)) + "'" + ", " + "'" + str(choice(imgs)) + "'" + "),", end="")
		format += 1
	print("\n")
		

def generate_quiz_answers():
	format = 0
	n = 0
	imgs = ["img_1", "img_2", "img_3", "img_4", "img_5", "img_6", "img_7", "img_8", "img_9", "img_10"]
	points = [1, 2, 3, 4, 5, 10]
	for i in range(0, 100):
		for i in range(0, 5):
			if format == 2:
				print("")
				format = 0
			else:
				print(" ", end="")
			print("(" + str(n) + ", " + str(i) + ", " + "'" + str("A quiz answer text") + "'" + ", " + str(choice(points)) + ", " + str(choice(["true", "false"])) + ", " + "'" + str(choice(imgs)) + "'" + "),", end="")
			n += 1
			format += 1
	print("\n")	


def generate_task():
	format = 0
	max_time = ["1 minute", "45 seconds", "30 seconds", "15 seconds", "10 seconds"]
	for i in range(0, 100):
		if format == 3:
			print("")
			format = 0
		else:
			print(" ", end="")
		print("(" + str(i) + ", " + "'" + str("A task text") + "'" + ", " + "'" + str(choice(max_time)) + "'" + "),", end="")
		format += 1
	print("\n")


def generate_task_answers():
	format = 0
	points = [1, 2, 3, 4, 5, 10]
	for i in range(0, 100):
		if format == 3:
			print("")
			format = 0
		else:
			print(" ", end="")
		print("(" + str(i) + ", " + str(i) + ", " + "'" + str("A task answer text") + "'" + ", " + str(choice(points)) + "),", end="")
		format += 1
	print("\n")
		

#generate_games()
generate_matches()
#generate_gameboard()
#generate_quiz()
#generate_quiz_answers()
#generate_task()
#generate_task_answers()
#generate_boxes()
