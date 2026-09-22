extends Node2D

@export var dimensions : Vector2i = Vector2i(10, 2)
@export var start : int = -1
@export var path_length : int = -1 
@export var chase : bool = false

var map : Array

var chase_start : int

func _ready() -> void:
	var current = _initialize_map()
	if chase:
		chase_start = _chase_sequence()
	else:
		chase_start = -1
	
	_initialize_path(current, path_length, chase_start)
	_print_map()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		map = []
		var current = _initialize_map()
		_initialize_path(current, path_length, chase_start)
		_print_map()

func _initialize_map() -> Vector2i:
	for x in dimensions.x:
		map.append([])
		for y in dimensions.y:
			map[x].append(0)
	#determines map length.
	
	if start < 0 or start >= dimensions.y:
		start = randi_range(0, dimensions.y - 1)
	map[0][start] = "S"
	#any value other than 0 and 1 have a randomized start. 
		
	return Vector2i(0, start)

func _print_map() -> void:
	var map_string: String = ""
	for y in range(dimensions.y - 1, -1, -1):
		for x in dimensions.x:
			if map[x][y]:
				map_string += "[" + str(map[x][y]) + "]"
			else:
				map_string += "   "
		map_string += "\n"
	print(map_string)
	
func _chase_sequence() -> int:
	chase_start = (dimensions.x / 2) 
	if (dimensions.x / 2) > 5:
		chase_start += randi_range(-2, 2)
	print(chase_start)
	return chase_start
	
func _initialize_path(current : Vector2i, length: int, chase_room : int) -> bool:
	var direction : Vector2i
	
	match randi_range(0, 6):
		0:
			direction = Vector2i.UP
		1:
			direction = Vector2i.DOWN
		_:
			direction = Vector2i.RIGHT
	#chooses whether the path will go "up", "down", or "right"
	
	if length == 0:
		if ( current.x + 1 <= dimensions.x - 1):
			map[current.x + 1][current.y] = "E"
		else:
			map[current.x][current.y] = "E"
		return true
	elif length == -1:
		length = dimensions.x
		#if no set path length, path length is the dimensions
	
	for i in 4:
		if (current.x + direction.x >= 0 and current.x + direction.x < dimensions.x and current.y + direction.y >= 0 and current.y + direction.y < dimensions.y and not map[current.x + direction.x][current.y + direction.y]):
			current += direction
			
			if current.x == chase_room:
				map[current.x][current.y] = "C"
			else:
				map[current.x][current.y] = length
			
			if _initialize_path(current, length - 1, chase_room):
				return true
			else: 
				map[current.x][current.y] = 0
				current -= direction
		direction = Vector2i.RIGHT
		#resets direction, makes map generate in the "right" direction	
	return false
	
