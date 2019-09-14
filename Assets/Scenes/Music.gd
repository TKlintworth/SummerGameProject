extends AudioStreamPlayer2D

func play_battle_music():
	stream = load("res://sounds/Music/BattleMusic.wav")
	play(0)