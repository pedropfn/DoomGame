extends Node2D

@onready var messageLabel = %Message
@onready var currentStoryFrame = 1

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_next_pressed() -> void:
	playIntro()

func _on_skip_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func playIntro():
	match currentStoryFrame:
		1:
			%StoryFrame2.show()
			messageLabel.text = " Eles protegem apenas os interesses daqueles que estão no poder"
			currentStoryFrame = 2
		2:
			%StoryFrame3.show()
			messageLabel.text = " Na academia eles aprendem que devem manter a ordem \n nos oprimem para que os que estão no poder possam nos usar"
			currentStoryFrame = 3
		3:
			%StoryFrame1.hide()
			%StoryFrame2.hide()
			%StoryFrame3.hide()
			%StoryFrame4.show()
			messageLabel.text = " NÃO MAIS !!"
			currentStoryFrame = 4
		4:
			get_tree().change_scene_to_file("res://scenes/world.tscn")
