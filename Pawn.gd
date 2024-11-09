extends Node
class_name Pawn

var color
var image
var movedOnce = false

func getMoves(board, pos):
	var moves = []
	for move in [Vector2i(1, 1), Vector2i(-1, 1)]:
		var currentMove = pos + move
		if currentMove not in board:
			continue
		var currentMoveColor = board[currentMove].getPieceColor()
		if currentMoveColor not in ['n', color]:
			moves.append(currentMove)
	var forwardMoves = [Vector2i(0, 1)]
	if not movedOnce:
		forwardMoves.append(Vector2i(0, 2))
	for move in forwardMoves:
		var currentMove = pos + move
		if currentMove not in board:
			return moves
		var currentMoveColor = board[currentMove].getPieceColor()
		if currentMoveColor == 'n':
			moves.append(currentMove)
		elif currentMoveColor != color:
			moves.append(currentMove)
			return moves
		else:
			return moves
	return moves
			

func _init(_color):
	self.color = _color
	image = load("res://pieces/pawn-" + color + ".svg")
