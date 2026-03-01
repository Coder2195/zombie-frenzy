class_name GameScene extends Node2D;

const Grass = preload("res://sprites/game_scene/grass.tscn");
const ZombieScene = preload("res://sprites/game_scene/zombie.tscn");

var last_pos = Vector2(0, 0);

signal new_wave(wave: int);

var chunk_map = {}

var stop_thread = false;

var thread;

func _ready():
  for x in range(-12, 12):
    for y in range(-8, 8):
      var grass = Grass.instantiate();
      grass.player_offset = Vector2(x, y);
      add_child(grass);

  generate_chunk(Vector2i(0, 0));
  
  regen_nav_map();

  generate_zombies();

  thread = Thread.new();
  thread.start(background_chunks.bind());


func _exit_tree() -> void:
  stop_thread = true;
  thread.wait_to_finish();

func background_chunks():
  while not stop_thread:
    await get_tree().create_timer(10.0).timeout;
    
    var player = get_node("Player");
    for _i in range(0, 5):
      var crate = Crate.create();
      crate.position = player.position + Vector2(randf_range(1000, 3000), 0).rotated(randf() * 2 * PI);
      
      
      get_node("/root/GameScene/").add_child.call_deferred(crate);
    if player == null:
      continue ;
    var current_chunk = $Player.position / 5000;
    var chunk_pos = Vector2i(round(current_chunk.x), round(current_chunk.y));
    
    for x in range(-1, 2):
      for y in range(-1, 2):
        var new_chunk_pos = chunk_pos + Vector2i(x, y);
        if not chunk_map.has(new_chunk_pos):
          generate_chunk.call_deferred(new_chunk_pos);
          
    
func generate_chunk(pos: Vector2i):
  for i in range(0, 50):
      var body = $StaticBody2D.duplicate() as StaticBody2D;
      body.position = Vector2(randf_range(pos.x * 5000 - 2500, pos.x * 5000 + 2500), randf_range(pos.y * 5000 - 2500, pos.y * 5000 + 2500));
      body.rotation = randf() * 2 * PI;
      add_child(body);

  print("Generated chunk: ", pos);

  chunk_map[pos] = true;


func regen_nav_map():
  var map: NavigationRegion2D = $NavRegion;
  var pos = $Player.global_position;
  var polygon = map.navigation_polygon;
  polygon.clear();
  polygon.add_outline([pos + Vector2(-3000, -3000), pos + Vector2(3000, -3000), pos + Vector2(3000, 3000), pos + Vector2(-3000, 3000)]);

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

func generate_zombies(wave = 1):
  print("Generating wave: ", wave);
  if (wave != 1):
    new_wave.emit(wave);
  for w in range(0, wave):
    for x in range(0, 10):
      var zombie: Zombie = ZombieScene.instantiate();
      zombie.position = $Player.position + Vector2(1000 + w * 200, 0).rotated(randf() * 2 * PI);
      zombie.movement_speed += wave * 30;
      $Zombies.add_child(zombie);
