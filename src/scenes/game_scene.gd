class_name GameScene extends Node2D;

const Grass = preload ("res://sprites/game_scene/grass.tscn");
const ZombieScene = preload ("res://sprites/game_scene/zombie.tscn");

var last_pos = Vector2(0, 0);

signal new_wave(wave: int);

func _ready():
  for x in range( - 12, 12):
    for y in range( - 8, 8):
      var grass = Grass.instantiate();
      grass.player_offset = Vector2(x, y);
      add_child(grass);

  for i in range(0, 50):
    var body = $StaticBody2D.duplicate() as StaticBody2D;
    body.position = Vector2(randf_range( - 2500, 2500), randf_range( - 2500, 2500));
    body.rotation = randf() * 2 * PI;
    add_child(body);

  regen_nav_map();

  generate_zombies();

func regen_nav_map():
  var map: NavigationRegion2D = $NavRegion;
  var pos = $Player.position;
  var polygon = map.navigation_polygon;
  polygon.clear();
  polygon.add_outline([pos + Vector2( - 3000, -3000), pos + Vector2(3000, -3000), pos + Vector2(3000, 3000), pos + Vector2( - 3000, 3000)]);

  map.navigation_polygon = polygon;

  map.bake_navigation_polygon();

func _process(_delta):
  var pos = $Player.position;

  if (pos.distance_to(last_pos) > 500):
    regen_nav_map();
    last_pos = pos;

  if ($Zombies.get_child_count() == 0):
    DataTracker.current_wave += 1;
    generate_zombies(DataTracker.current_wave);

func generate_zombies(wave=1):
  print("Generating wave: ", wave);
  if (wave != 1):
    new_wave.emit(wave);
  for w in range(0, wave):
    for x in range(0, 10):
      var zombie = ZombieScene.instantiate();
      zombie.position = $Player.position + Vector2(1000 + w * 200, 0).rotated(randf() * 2 * PI);
      $Zombies.add_child(zombie);
