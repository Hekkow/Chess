extends Node
class_name Bishop

var color
var image

func get_moves(board, pos):
	var moves = []
	var directions = [Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, -1), Vector2i(-1, 1)]
	
	for i in range(len(directions)):
		var current_move = pos
		while true:
			current_move = current_move + directions[i]
			if current_move not in board:
				break
			var current_move_color = board[current_move].get_piece_color()
			if current_move_color == color:
				break
			else:
				moves.append(current_move)
				if current_move_color != 'n':
					break
	return moves
			

func _init(_color):
	self.color = _color
	image = load("res://pieces/bishop-" + color + ".svg")
