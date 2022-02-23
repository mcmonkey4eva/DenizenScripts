# dEssentials: Things a servers needs in one easy package!
# --- CONTROL: Commands to control server information.
# See dEssentials-Core.yml for information

dessentials_command_time:
    type: command
    debug: false
    name: time
    description: Sets the world's time.
    usage: /time <&lt>time<&gt> [world]
    permission: denizen.essentials.admin.time
    script:
    - if <context.server> && <context.args.size> != 2:
      - narrate "<&c>This command is for players only."
      - narrate "<&c>Available for the server<&co> /time <&lt>time<&gt> <&lt>world<&gt>"
      - stop
    - if <context.args.size> == 0:
      - narrate "<&c>/time <&lt>time<&gt> [world]"
      - define hour <player.world.time.div[1000].add[6].round>
      - if <[hour]> >= 24:
        - define hour <[hour].sub[24]>
      - narrate "<&2>Time in <&b><player.world.name><&2> is <&b><player.world.time>ticks<&2> (<&b><[hour]> o' clock<&2>)."
      - stop
    - define world <player.world>
    - if <context.args.size> == 2:
      - define world <world[<context.args.get[2]>]||nul>
    - if <[world].name||null> == null:
      - narrate "<&c>Unknown world."
      - stop
    - define time <context.args.get[1]>
    - if <[time].is[==].to[day]>:
      - adjust <[world]> time:0
    - else if <[time].is[==].to[night]>:
      - adjust <[world]> time:15000
    - else if <[time].is[==].to[dawn]>:
      - adjust <[world]> time:23000
    - else if <[time].is[==].to[dusk]>:
      - adjust <[world]> time:13000
    - else if <[time].contains[<&co>]>:
      - adjust <[world]> time:<[time].before[<&co>].sub[6].mul[1000].add[<[time].after[<&co>].mul[16.666]>]>
    - else if <[time].ends_with[ticks]>:
      - adjust <[world]> time:<[time].before[ticks]>
    - else:
      - adjust <[world]> time:<[time].sub[6].mul[1000]>
    - define hour <player.world.time.div[1000].add[6].round>
    - if <[hour]> >= 24:
      - define hour <[hour].sub[24]>
    - narrate "<&2>Set time in <&b><[world].name><&2> to <&b><[world].time>ticks<&2> (<&b><[hour]> o' clock<&2>)."

dessentials_command_day:
    type: command
    debug: false
    name: day
    description: Changes the world time to day!
    usage: /day
    permission: denizen.essentials.admin.time
    script:
    ## TODO /day [world]
    - if <context.server>:
      - narrate "<&c>This command is for players only."
      - stop
    - if <context.args> > 0:
      - narrate "<&c>/day"
      - stop
    - adjust <player.world> time:0
    - narrate "Changed time to day in <player.world.name>"

dessentials_command_night:
    type: command
    name: night
    description: Changes the world time to night!
    usage: /night
    permission: denizen.essentials.admin.time
    script:
    ## TODO /night [world]
    - if <context.server>:
      - narrate "<&c>This command is for players only."
      - stop
    - if <context.args> > 0:
      - narrate "<&c>/night"
      - stop
    - adjust <player.world> time:13500
    - narrate "Changed time to night in <player.world.name>"

dessentials_command_speed:
    type: command
    debug: false
    name: speed
    description: Sets the player's speed.
    usage: /speed <&lt>speed<&gt>
    permission: denizen.essentials.admin.speed
    script:
    # TODO: / speed <speed> <player>
    - if <context.server>:
      - narrate "<&c>This command is for players only."
      - stop
    - if <context.args.size> == 0:
      - narrate "<&c>/speed <&lt>speed<&gt>"
      - stop
    - define speed <context.args.get[1].escaped.replace[&dot].with[.]>
    - if <player.is_flying>:
      - adjust <player> fly_speed:<[speed]>
      - narrate "<&2>Player <&b>fly <&2>speed set to <&b><player.fly_speed><&2>."
    - else:
      - adjust <player> walk_speed:<[speed]>
      - narrate "<&2>Player <&b>walk <&2>speed set to <&b><player.walk_speed><&2>."

dessentials_command_butcher:
  type: command
  name: butcher
  description: Butchers all mobs/animals within a radius. Radius defaults to 25 if empty.
  usage: /butcher [mobs/animals/ambient/list] [radius]
  permission: denizen.essentials.admin.butcher
  ## TODO type: all
  types: mobs|animals|ambient
  mobs: spider|creeper|cave_spider|slime|zombie|skeleton|witch|silverfish|enderman
  animals: bat|chicken|cow|pig|rabbit|sheep|squid|mushroom_cow
  ambient: ocelot|wolf|iron_golem|horse|villager
  script:
  - if <context.server>:
    - narrate "<&c>This command is for players only."
    - stop
  - if <context.args.size> == 0:
    - narrate "<&c>/butcher [mobs/animals/ambient/list] [radius]"
    - stop
  - define type mobs
  - define radius 25
  - if <context.args.size> == 1:
    - define type <context.args.get[1]||null>
    - if <[type]> == list:
      - narrate "<&2>Valid types are: <&b><script.data_key[types].as_list.formatted>"
      - stop
  - else if <context.args.size> == 2:
    - define type <context.args.get[1]||null>
    - define radius <context.args.get[2]||null>
  - if !<script.data_key[types].as_list.contains[<[type]>]>:
    - narrate "<&c>Invalid type."
    - stop
  - if <[radius]> == null:
    - narrate "<&c>Invalid radius."
    - stop
  - define butcher <player.location.find_entities[<script.data_key[<[type]>]>].within[<[radius]>].filter[is_npc.not].filter[is_player.not]>
  - narrate "<&2>Removing <&b><[butcher].size><&2> entities within <&b><[radius]><&2> blocks of type <&b><[type]><&2>."
  - remove <[butcher]>
