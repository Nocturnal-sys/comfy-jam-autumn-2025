extends Node

const SPRITES: Array[CompressedTexture2D] = [
	preload("res://assets/sprites/carrot.png"),
	preload("res://assets/sprites/leek.png"),
	preload("res://assets/sprites/mushroom.png"),
	preload("res://assets/sprites/onion.png"),
	preload("res://assets/sprites/potato.png"),
	preload("res://assets/sprites/pumpkin.png"),
	preload("res://assets/sprites/squash.png")
]

const NUM_SPRITES: int = len(SPRITES)
const GRID_SIZE: int = 8

enum State {
	WAITING,
	READY,
	SELECTED
}

var current_state: State = State.WAITING
var selected_index: int = -1
var selected_type: int = -1
var highlighted: PackedInt32Array = PackedInt32Array()
var offsets: PackedInt32Array = PackedInt32Array([
	-1, 1, -GRID_SIZE, GRID_SIZE
])

func get_new_type() -> int:
	return randi() % NUM_SPRITES


func set_waiting() -> void:
	current_state = State.WAITING
	reset_selected()


func set_ready() -> void:
	current_state = State.READY
	reset_selected()


func set_selected(vegetable: Vegetable) -> void:
	current_state = State.SELECTED
	selected_index = vegetable.index
	selected_type = vegetable.type
	highlighted = vegetable.adjacent.duplicate()


func reset_selected() -> void:
	selected_index = -1
	selected_type = -1
	highlighted.clear()
