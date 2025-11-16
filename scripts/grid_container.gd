extends GridContainer

const GRID_SIZE: int = GameManager.GRID_SIZE
var grid: Array[PackedInt32Array] = []

signal grid_updated


func _ready() -> void:
	set_columns(GRID_SIZE)
	_add_items()


func _process(_delta: float) -> void:
	pass


func _add_items() -> void:
	for i in GRID_SIZE:
		grid.append(PackedInt32Array())
		for j in GRID_SIZE:
			var vegetable: Vegetable = Vegetable.new()
			grid[i].append(vegetable.type)
			add_child(vegetable)

	grid_updated.emit()


func _update_items() -> void:
	GameManager.set_waiting()

	for i in GRID_SIZE:
		for j in GRID_SIZE:
			var index: int = i * GRID_SIZE + j
			var vegetable: Vegetable = get_child(index)
			vegetable.type = grid[i][j]

	grid_updated.emit()


func _on_grid_updated() -> void:
	var matches: Array[PackedVector2Array] = check_matches()

	if matches.size() > 0:
		set_matches(matches)
	else:
		GameManager.set_ready()


func check_matches() -> Array[PackedVector2Array]:
	var matches: Array[PackedVector2Array] = []

	for n in GRID_SIZE:
		matches.append_array(_check_row(n))
		matches.append_array(_check_column(n))

	return matches


func _check_row(i: int) -> Array[PackedVector2Array]:
	var matches: Array[PackedVector2Array] = []
	var match_group: PackedVector2Array = [Vector2i(i, 0)]

	for j in range(1, GRID_SIZE):
		if grid[i][j - 1] == grid[i][j]:
			match_group.append(Vector2i(i, j))
			continue

		if match_group.size() >= 3:
			matches.append(match_group.duplicate())

		match_group.clear()
		match_group.append(Vector2i(i, j))

	return matches


func _check_column(j: int) -> Array[PackedVector2Array]:
	var matches: Array[PackedVector2Array] = []
	var match_group: PackedVector2Array = [Vector2i(0, j)]

	for i in range(1, GRID_SIZE):
		if grid[i - 1][j] == grid[i][j]:
			match_group.append(Vector2i(i, j))
			continue

		if match_group.size() >= 3:
			matches.append(match_group.duplicate())

		match_group.clear()
		match_group.append(Vector2i(i, j))

	return matches


func set_matches(matches: Array[PackedVector2Array]) -> void:
	if matches.is_empty():
		return

	for group: PackedVector2Array in matches:
		for item: Vector2i in group:
			_set_match(item.x, item.y)

	_update_grid()


func _set_match(i: int, j: int) -> void:
	var current: int = grid[i][j]
	grid[i][j] = current - 1 if current < 0 else -1


func _update_grid() -> void:
	for n in GRID_SIZE:
		_update_column(n)

	_update_items()


func _update_column(j: int) -> void:
	var count: int = 0

	for i in range(GRID_SIZE - 1, -1, -1):
		if grid[i][j] < 0:
			count += 1
		elif count > 0:
			grid[i + count][j] = grid[i][j]

	for i in count:
		grid[i][j] = GameManager.get_new_type()


func try_swap(a: int, b: int) -> void:
	reset_grid()
	if _try_swap(_convert(a), _convert(b)):
		_update_items()


func _try_swap(a: Vector2i, b: Vector2i) -> bool:
	_swap(a, b)
	if _check_local_matches(a) or _check_local_matches(b):
		return true
	else:
		_swap(a, b)
		return false


func _check_local_matches(start: Vector2i) -> bool:
	for axis in [
		[Vector2i.LEFT, Vector2i.RIGHT],
		[Vector2i.UP, Vector2i.DOWN]
	]:
		var count: int = 0
		for direction in axis:
			count += _check_direction(start, direction)
			if count >= 2: return true

	return false


func _check_direction(start: Vector2i, direction: Vector2i) -> int:
	var count: int = 0
	var next: Vector2i = start + direction

	while next >= Vector2i.ZERO and _check_match(start, next):
		count += 1
		next += direction

	return count


func _check_match(a: Vector2i, b: Vector2i) -> bool:
	return grid[a.x][a.y] == grid[b.x][b.y]


func reset_grid() -> void:
	for i in GameManager.highlighted:
		get_child(i).set_highlight(false)


func shuffle_grid() -> void:
	for n in range(GRID_SIZE * GRID_SIZE - 1, 0, -1):
		var k: int = randi_range(0, n)
		_swap(_convert(n), _convert(k))

	_update_items()


func _swap(a: Vector2i, b: Vector2i) -> void:
	var temp: int = grid[a.x][a.y]
	grid[a.x][a.y] = grid[b.x][b.y]
	grid[b.x][b.y] = temp


func _convert(n: int) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(n / GRID_SIZE, n % GRID_SIZE)
