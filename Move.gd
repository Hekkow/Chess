extends Node
class_name Move

var fromSquare: Square
var toSquare: Square

func _init(_fromSquare: Square, _toSquare: Square) -> void:
	self.fromSquare = _fromSquare
	self.toSquare = _toSquare
func activate() -> void:
	var piece = fromSquare.piece
	if piece is Pawn:
		piece.movedOnce = true
	toSquare.setPiece(piece)
	fromSquare.setPiece(null)
