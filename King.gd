extends Node
class_name King

var color
var image

func get_moves(board, pos):
	var moves = []
	var attack_moves = []
	for key in board:
		var current_square = board[key]
		if current_square.get_piece_color() not in [color, 'n']:
			if current_square.piece and current_square.piece is Pawn:
				attack_moves.append_array(current_square.piece.get_attack_moves(board, current_square.pos))
				print("HERE?")
			else:
				attack_moves.append_array(current_square.get_moves(board))
	for i in range(-1, 2):
		for j in range(-1, 2):
			var current_move = pos + Vector2i(i, j)
			if current_move not in board or current_move == pos or board[current_move].get_piece_color() == color:
				continue
			if current_move not in attack_moves:
				moves.append(Vector2i(i, j) + pos)
	return moves
			

func _init(_color):
	self.color = _color
	image = load("res://pieces/king-" + color + ".svg")
