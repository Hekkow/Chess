extends Node2D

@onready var piece_scene = load("res://square.tscn")
@onready var undo_button = $CanvasLayer/Container/HBoxContainer/Undo
@onready var redo_button = $CanvasLayer/Container/HBoxContainer/Redo

var viewing_moves := false
var currently_selected: Square
var possible_moves
var previous_moves = []
var next_moves = []
var currently_highlighted = []
var starting_pieces = {
	Vector2i(0, 1): [Pawn, "w"],
	Vector2i(1, 1): [Pawn, "w"],
	Vector2i(2, 1): [Pawn, "w"],
	Vector2i(3, 1): [Pawn, "w"],
	Vector2i(4, 1): [Pawn, "w"],
	Vector2i(5, 1): [Pawn, "w"],
	Vector2i(6, 1): [Pawn, "w"],
	Vector2i(7, 1): [Pawn, "w"],
	Vector2i(7, 6): [Pawn, "b"],
	Vector2i(7, 3): [Pawn, "b"],
	Vector2i(5, 5): [Rook, "b"],
	Vector2i(5, 6): [Bishop, "w"],
	Vector2i(5, 7): [Queen, 'w'],
	Vector2i(4, 5): [Knight, 'w'],
	Vector2i(5, 2): [King, 'w'],
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
		if square in possible_moves and currently_selected != square:
			var move = Move.new(currently_selected, square)
			reset()
			previous_moves.append(move)
			move.activate()
			next_moves = []
			
		elif not square.piece or currently_selected == square:
			unhighlight_squares()
			viewing_moves = false
		elif square.get_piece_color() == currently_selected.get_piece_color():
			unhighlight_squares()
			highlight_squares(square)
			currently_selected = square
	else:
		if square.piece and square.get_piece_color() == turn:
			highlight_squares(square)
			viewing_moves = true
			currently_selected = square

func swap_turn():
	turn = ['w', 'b'].filter(func (t): return t != turn)[0]

func highlight_squares(square):
	currently_highlighted = square.get_moves(board).map(func (s): return board[s])
	possible_moves = currently_highlighted
	currently_highlighted.append(square)
	for s in currently_highlighted:
		s.highlight()
func unhighlight_squares():
	for square in currently_highlighted:
		square.unhighlight()
func undo():
	
	var previous_move = previous_moves.pop_back()
	if not previous_move:
		return
	previous_move.undo()
	next_moves.append(previous_move)
	reset()
	
func redo():
	var next_move = next_moves.pop_back()
	if not next_move:
		return
	next_move.activate()
	previous_moves.append(next_move)
	reset()

func reset():
	unhighlight_squares()
	possible_moves = []
	viewing_moves = false
	currently_selected = null
	swap_turn()


