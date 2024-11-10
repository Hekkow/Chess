extends Node2D

@onready var piece_scene = load("res://square.tscn")
@onready var undo_button = $CanvasLayer/Container/HBoxContainer/Undo
@onready var redo_button = $CanvasLayer/Container/HBoxContainer/Redo

var viewing_moves := false
var currently_selected: Square
var possible_moves
var previous_moves = []
var next_moves = []
var starting_pieces = {
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

var turn = 'w'

func _ready():
	for i in 64:
		var square = piece_scene.instantiate()
		var pos = Vector2i(i % 8, (i / 8))
		square.setXY(pos)
		square.clicked.connect(on_piece_clicked)
		
		add_child(square)
		if pos in starting_pieces:
			var piece = starting_pieces[pos]
			square.setPiece(piece[0], piece[1])
		board[pos] = square
	undo_button.pressed.connect(undo)
	redo_button.pressed.connect(redo)
	
		
func on_piece_clicked(square: Square):
	if viewing_moves:
		if square in possible_moves:
			highlight_squares(currently_selected.getMoves(board), currently_selected, false)
			var move = Move.new(currently_selected, square)
			previous_moves.append(move)
			move.activate()
			next_moves = []
			possible_moves = []
			viewing_moves = false
			currently_selected = null
			swap_turn()
		elif not square.piece or currently_selected == square:
			highlight_squares(square.getMoves(board), square, false)
			viewing_moves = false
		elif square.getPieceColor() == currently_selected.getPieceColor():
			highlight_squares(currently_selected.getMoves(board), currently_selected, false)
			highlight_squares(square.getMoves(board), square, true)
		
	else:
		if square.piece and square.getPieceColor() == turn:
			highlight_squares(square.getMoves(board), square, true)
			viewing_moves = true
	currently_selected = square

func swap_turn():
	turn = ['w', 'b'].filter(func (t): return t != turn)[0]

func highlight_squares(squares, current, on):
	squares = squares.map(func (s): return board[s])
	if on:
		possible_moves = squares
		current.highlight()
		for square in squares:
			square.highlight()
	else:
		current.unhighlight()
		for square in squares:
			square.unhighlight()

func undo():
	var previous_move = previous_moves.pop_back()
	if not previous_move:
		return
	previous_move.undo()
	next_moves.append(previous_move)
func redo():
	var next_move = next_moves.pop_back()
	if not next_move:
		return
	next_move.activate()
	previous_moves.append(next_move)



