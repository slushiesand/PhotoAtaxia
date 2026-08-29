extends Node2D

@export var dimensions : Vector2i = Vector2i(10, 2)
@export var start : int = -1
@export var path_length : int = -1 
@export var chase : bool = false

var map : Array

var chase_start : Vector2i

func _ready() -> void:
	var current = _initialize_map()
	_initialize_path(current, path_length)
	_print_map()

func _process(delta: float) -> void:
	pass

func _initialize_map() -> Vector2i:
	for x in dimensions.x:
		map.append([])
		for y in dimensions.y:
			map[x].append(0)
	
	if start < 0 or start >= dimensions.y:
		start = randi_range(0, dimensions.y - 1)
	map[0][start] = "S"
	
	if chase:
		_chase_sequence()
		
	return Vector2i(0, start)

func _print_map() -> void:
	var map_string: String = ""
	for y in range(dimensions.y - 1, -1, -1):
		for x in dimensions.x:
			map_string += "[" + str(map[x][y]) + "]"
		map_string += "\n"
	print(map_string)
	
func _chase_sequence() -> void:
	chase_start.x = (dimensions.x / 2) 
	if (dimensions.x / 2) > 5:
		chase_start.x += randi_range(-2, 2)
	print(chase_start.x)
	chase_start.y = randi_range(0, dimensions.y - 1)
	
	map[chase_start.x][chase_start.y] = "C"
	
func _initialize_path(current : Vector2i, length: int) -> bool:
	var direction : Vector2i
	
	match randi_range(0, 2):
		0:
			direction = Vector2i.UP
		1:
			direction = Vector2i.LEFT
		2:
			direction = Vector2i.DOWN
	
	if length == 0:
		if (current.x + direction.x < dimensions.x):
			map[current.x + 1][current.y] = "E"
		else:
			map[current.x][current.y] = "E"
		return true
	elif length == -1:
		length = dimensions.x
	
	for i in 3:
		if (current.x + direction.x >= 0 and current.x + direction.x < dimensions.x and current.y + direction.y >= 0 and current.y + direction.y < dimensions.y and not map[current.x + direction.x][current.y + direction.y]):
			current += direction
			map[current.x][current.y] = length
			if _initialize_path(current, length - 1):
				return true
			else: 
				map[current.x][current.y] = 0
				current -= direction
		direction = Vector2(-direction.y, direction.x)
	
	return false
	
