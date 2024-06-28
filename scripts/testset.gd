extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("uo") == true:
		position.y -= 30
	if Input.is_action_pressed("down") == true:
		position.y += 10
	if Input.is_action_pressed("left") == true:
		position.x -= 10
	if Input.is_action_pressed("right") == true:
		position.x += 10
