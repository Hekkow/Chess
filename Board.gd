extends Node2D

@onready var pieceScene = load("res://square.tscn")

var viewingMoves := false
var currentlySelected: Square
var possibleMoves
var previousMoves = []

var startingPieces = {
	Vector2i(0, 1): [Pawn, "w"],
	Vector2i(1, 1): [Pawn, "w"],
	Vector2i(2, 1): [Pawn, "w"],
	Vector2i(3, 1): [Pawn, "w"],
	Vector2i(4, 1): [Pawn, "w"],
	Vector2i(5, 1): [Pawn, "w"],
	Vector2i(6, 1): [Pawn, "w"],
	Vector2i(7, 1): [Pawn, "w"],
	Vector2i(7, 3): [Pawn, "b"],
}

var board = {}

func _ready():
	for i in 64:
		var square = pieceScene.instantiate()
		var pos = Vector2i(i % 8, (i / 8))
		square.setXY(pos)
		square.clicked.connect(on_piece_clicked)
		
		add_child(square)
		if pos in startingPieces:
			var piece = startingPieces[pos]
			square.setPiece(piece[0], piece[1])
		board[pos] = square
	
		
func on_piece_clicked(square: Square):
	if viewingMoves:
		if square in possibleMoves:
			highlightSquares(currentlySelected.getMoves(board), currentlySelected, false)
			var move = Move.new(currentlySelected, square)
			previousMoves.append(move)
			move.activate()
			previousMoves = []
			viewingMoves = false
			currentlySelected = null
		elif not square.piece or currentlySelected == square:
			highlightSquares(square.getMoves(board), square, false)
			viewingMoves = false
		elif square.getPieceColor() == currentlySelected.getPieceColor():
			highlightSquares(currentlySelected.getMoves(board), currentlySelected, false)
			highlightSquares(square.getMoves(board), square, true)
		
	else:
		if square.piece:
			highlightSquares(square.getMoves(board), square, true)
			viewingMoves = true
	currentlySelected = square


func highlightSquares(squares, current, on):
	squares = squares.map(func (s): return board[s])
	if (on):
		possibleMoves = squares
		current.highlight()
		for square in squares:
			square.highlight()
	else:
		current.unhighlight()
		for square in squares:
			square.unhighlight()

