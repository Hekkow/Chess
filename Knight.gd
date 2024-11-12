extends Node
class_name Knight

var color
var image

func get_moves(board, pos):
	var moves = []
	for move in [Vector2i(2, 1), Vector2i(1, 2), Vector2i(-1, 2), Vector2i(-2, 1), Vector2i(2, -1), Vector2i(1, -2), Vector2i(-1, -2), Vector2i(-2, -1)]:
		var current_move = pos + move
		if current_move in board and board[current_move].get_piece_color() != color:
			moves.append(current_move)
	return moves
			

func _init(_color):
	self.color = _color
	image = load("res://pieces/knight-" + color + ".svg")
