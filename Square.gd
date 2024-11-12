extends Node2D
class_name Square

var highlighted_color = Color(0.29676380753517, 0.60680210590363, 0.43968760967255, 0.77647060155869)
var pos: Vector2i
@onready var background := $Background
@onready var backgroundHighlight := $Highlight
@onready var sprite := $Sprite2D
signal clicked(square)
var piece

func _ready():
	position = Vector2(pos.x*background.size.x, (7-pos.y)*background.size.y)
	if (8*pos.y+pos.x+pos.y%2+1) % 2 == 0: # no idea what this means but it works from the last time i tried this
		background.color = Color(0.29857668280602, 0.74303960800171, 0.93028396368027)
	else:
		background.color = Color(0.99607843160629, 0.89803922176361, 0.59607845544815)
	background.gui_input.connect(on_click)
	var label = Label.new()
	add_child(label)
	label.text = str(pos)
	
func on_click(event: InputEvent):
	if event.is_action_pressed("click"):
		clicked.emit(self)
		
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
func get_moves(board):
	if not piece:
		return []
	return piece.get_moves(board, pos)
	
func get_piece_color():
	if piece:
		return piece.color
	else:
		return "n"
func highlight():
	backgroundHighlight.color = highlighted_color
func unhighlight():
	backgroundHighlight.color = Color.TRANSPARENT

func p():
	print(pos)
