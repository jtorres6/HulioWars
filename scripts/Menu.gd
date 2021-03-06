extends CanvasLayer

var fade 

func _ready():
	fade = get_node("Fade")

func _on_PlayButton_pressed():
	$Play.disabled = true
	fade._loadScene("res://Scenes/MainScene.tscn")
	fade.fading_out = true

func _on_Exit_pressed():
	get_tree().quit()

func _on_Credits_pressed():
	$Credits.disabled = true
	fade._loadScene("res://Scenes/Credits.tscn")
	fade.fading_out = true

func _on_MenuTheme_finished():
	$MenuTheme.play()
