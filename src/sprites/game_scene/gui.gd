class_name GUI extends CanvasLayer

func set_health(health: float):
  $Control/Health.value = health;

func set_stamina(stamina: float):
  $Control/Stamina.value = stamina;

func set_wave(wave: int):
  var voices = DisplayServer.tts_get_voices_for_language("en")
  if (voices.size() != 0):
    var voice_id = voices[randi() % voices.size()];
    print(voices)
    DisplayServer.tts_speak("Wave: " + str(wave), voice_id, 150)

  $Control/Wave.text = "[center]Wave: " + str(wave) + "[/center]";
  var tween = get_tree().create_tween();
  tween.set_trans(Tween.TRANS_EXPO);
  tween.tween_property($Control/Wave, "scale", Vector2(1, 1), 1);
  await get_tree().create_timer(3.0).timeout;
  tween = get_tree().create_tween();
  tween.set_trans(Tween.TRANS_EXPO);
  tween.tween_property($Control/Wave, "scale", Vector2(0, 0), 1);

func _ready():
  set_wave(1);
