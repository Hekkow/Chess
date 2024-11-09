extends Node2D
class_name Square

var highlighted_color = Color(0.8901960849762, 0.45882353186607, 0.59607845544815, 0.77647060155869)
var pos: Vector2i
@onready var background := $Background
@onready var backgroundHighlight := $Highlight
@onready var sprite := $Sprite2D
signal clicked(square)
var piece

func _ready():
	position = Vector2(pos.x*background.size.x, (7-pos.y)*background.size.y)
	if (8*pos.y+pos.x+pos.y%2+1) % 2 == 0: # no idea what this means but it works from the last time i tried this
		background.color = Color(0.11489679664373, 0.1148968115449, 0.11489679664373)
	else:
		background.color = Color(0.86467510461807, 0.86467516422272, 0.86467510461807)
	background.gui_input.connect(on_click)
	
func on_click(event: InputEvent):
	if event.is_action_pressed("click"):
		clicked.emit(self)
		#setPiece(Pawn.new("w"))
		
func setXY(_pos):
	self.pos = _pos

func setPiece(_piece, _color = null):
	if not _piece:
		piece = null
		sprite.texture = null
		return
	if _piece is Script:
		piece = _piece.new(_color)
	else:
		piece = _piece
	sprite.texture = piece.image
func getMoves(board):
	if not piece:
		return []
	return piece.getMoves(board, pos)
	
func getPieceColor():
	if piece:
		return piece.color
	else:
		return "n"
func highlight():
	backgroundHighlight.color = highlighted_color
func unhighlight():
	backgroundHighlight.color = Color.TRANSPARENT
