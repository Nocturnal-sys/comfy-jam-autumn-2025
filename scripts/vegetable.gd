class_name Vegetable
extends TextureButton

var type: int
var index: int
var parent: Container
var highlighted: bool
var adjacent: Array[int] = []


func _init() -> void:
	type = GameManager.get_new_type()
	highlighted = false
	set_texture_normal(GameManager.SPRITES[type])


func _ready() -> void:
	index = self.get_index()
	parent = self.get_parent()


func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	match GameManager.current_state:

		GameManager.State.READY:
			_highlight_adjacent()
			GameManager.set_selected(self)

		GameManager.State.SELECTED:
			if highlighted and _check_swap():
				GameManager.swap(self.index)
				return

			_reset_all()
			GameManager.set_ready()


func highlight() -> void:
	highlighted = true


func reset() -> void:
	highlighted = false


func _highlight_adjacent() -> void:
	for i in _get_adjacent():
		parent.get_child(i).highlight()


func _get_adjacent() -> Array[int]:
	if adjacent.size() > 0:
		return adjacent

	adjacent = [
		index - 1,
		index + 1,
		index - GameManager.GRID_SIZE,
		index + GameManager.GRID_SIZE
	].filter(_is_in_range)

	return adjacent


func _is_in_range(i: int) -> bool:
	return 0 <= i and i < GameManager.GRID_SIZE ** 2


func _check_swap() -> bool:
	# TODO: return true if valid swap
	return false


func _reset_all() -> void:
	for i in GameManager.highlighted:
		parent.get_child(i).reset()
