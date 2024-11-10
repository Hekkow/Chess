extends Node
class_name Move

var from_square: Square
var to_square: Square
var original_from_piece
var original_to_piece
var set_pawn_moved_once = false

func _init(_from_square: Square, _to_square: Square) -> void:
	self.from_square = _from_square
	self.to_square = _to_square
func activate() -> void:
	original_from_piece = from_square.piece
	original_to_piece = to_square.piece
	if original_from_piece is Pawn and not original_from_piece.movedOnce:
		original_from_piece.movedOnce = true
		set_pawn_moved_once = true
	to_square.setPiece(original_from_piece)
	from_square.setPiece(null)
func undo() -> void:
	from_square.setPiece(original_from_piece)
	to_square.setPiece(original_to_piece)
	if set_pawn_moved_once:
		original_from_piece.movedOnce = false
		set_pawn_moved_once = false
