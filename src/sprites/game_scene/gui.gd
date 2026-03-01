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
  set_selected(0);
  set_wave(1);
  $Control/Damage.visible = true;

func set_selected(index: int):
  $Control/Inventory/Selection.position.x = index * 126 - 440;

var last_damage_time = -1000;

func take_damage():
  last_damage_time = Time.get_ticks_msec();
  $Control/Damage.color.a = 0.5;

func _process(delta: float) -> void:
  $Control/Damage.color.a = max(0, 0.5 - (Time.get_ticks_msec() - last_damage_time) / 1000.0);

func set_inventory(items: Array[Player.ItemData]):
  for i in range(len(items)):
    var item = items[i];
    var item_node = $Control/Inventory/Items.get_child(i) as Item;
    if item == null:
      item_node.visible = false;
    else:
      item_node.visible = true;
      item_node.animation = item.name;
      item_node.count_visible = item.count > 1;
      item_node.set_count(item.count);
