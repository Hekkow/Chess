extends Node
class_name Pawn

var color
var image
var movedOnce = false

func get_moves(board, pos):
	var moves = []
	var c = 1 if color == 'w' else -1
	moves = get_attack_moves(board, pos)
	var forwardMoves = [Vector2i(0, 1 * c)]
	if not movedOnce:
		forwardMoves.append(Vector2i(0, 2 * c))
	for move in forwardMoves:
		var currentMove = pos + move
		if currentMove not in board:
			return moves
		var currentMoveColor = board[currentMove].get_piece_color()
		if currentMoveColor == 'n':
			moves.append(currentMove)
		else:
			return moves
	return moves

func get_attack_moves(board, pos):
	var moves = []
	var c = 1 if color == 'w' else -1
	for move in [Vector2i(1, 1 * c), Vector2i(-1, 1 * c)]:
		var currentMove = pos + move
		if currentMove not in board:
			continue
		moves.append(currentMove)
	return moves

func _init(_color):
	self.color = _color
	image = load("res://pieces/pawn-" + color + ".svg")
