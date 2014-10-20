# |----------------------
# |
# | Chest Locker
# |
# | Lock chests with signs.
#
# @author mcmonkey
# @date 2014 / 10 / 19
# @build 1534
# @version 1.0
#
# ---------------------------- END HEADER ----------------------------

chestlocker_settings:
    type: yaml data
    chests:
    - chest
    - trapped_chest
    no_output:
    - wood_plate
    - stone_plate
    blocks:
    - lever
    - wood_button
    - stone_button
    - wood_plate
    - stone_plate
    - furnace
    - burning_furnace
    - dispenser
    - dropper
    - jukebox
    - note_block
    - hopper
    doors:
    - wooden_door
    - iron_door_block
    - spruce_door
    - birch_door
    - acacia_door
    - dark_oak_door
    - small_doors:
    - trap_door
    - fence_gate
    - birch_fence_gate
    - spruce_fence_gate
    - jungle_fence_gate
    - dark_oak_fence_gate
    - acacia_fence_gate

chestlocker_is_lockable_procedure:
    type: procedure
    definition: material
    script:
    - define mats <s@chestlocker_settings.yaml_key[chests]>
    - define mats <def[mats].include[<s@chestlocker_settings.yaml_key[no_output]>]>
    - define mats <def[mats].include[<s@chestlocker_settings.yaml_key[blocks]>]>
    - define mats <def[mats].include[<s@chestlocker_settings.yaml_key[doors]>]>
    - define mats <def[mats].include[<s@chestlocker_settings.yaml_key[small_doors]>]>
    - if %mats% contains %material% {
      - determine true
      }
      else {
      - determine false
      }

chestlocker_check_canonical_procedure:
    type: procedure
    definitions: location
    script:
    # North/West/South/East
    - define directions li@1,0,0|-1,0,0|0,0,1|0,0,-1
    - inject locally check_direction
    # NorthNorth/WestWest/SouthSouth/EastEast
    - define directions li@2,0,0|-2,0,0|0,0,2|0,0,-2
    - inject locally check_direction
    # TODO
    - determine null
    check_direction:
    - foreach %directions% {
      - if <proc[chestlocker_is_lockable_procedure].context[<def[location].add[%value%].material.bukkit_enum>]> {
        - determine <def[location].add[%value%]>
        }
      }

chestlocker_check_locksign_procedure:
    type: procedure
    definition: sign
    script:
    - if <def[sign].sign_contents.get[1].strip_color> == [lock] {
      - determine true
      }
      else if <def[sign].sign_contents.get[1].strip_color> == [private] {
      - determine true
      }
      else {
      - determine false
      }

chestlocker_check_lockmoresign_procedure:
    type: procedure
    definition: sign
    script:
    - if <def[sign].sign_contents.get[1].strip_color> == "[more users]" {
      - determine true
      }
      else {
      - determine false
      }


chestlocker_check_allowed_line_procedure:
    type: procedure
    definitions: line
    script:
    - if <player.name.substring[1,15].is[==].to[%line%]> {
      - determine true
      }
    - if <def[line].is[==].to[<&lb>everyone<&rb>]> {
      - determine true
      }
    - if <def[line].starts_with[g<&co>]> && <def[line].length> > 2 {
      - if <player.in_group[<def[line].substring[3]>]> {
        - determine true
        }
      }
    - determine false

chestlocker_check_allowed_sign_procedure:
    type: procedure
    definitions: sign
    script:
    - foreach li@2|3|4 {
      - if <proc[chestlocker_check_allowed_line_procedure].context[<def[sign].sign_contents.get[%value%]>]> {
        - determine true
        }
      }
    - determine false

chestlocker_check_allowed_hopper_procedure:
    type: procedure
    definitions: sign
    script:
    - foreach li@2|3|4 {
      - if <def[sign].sign_contents.get[%value%].starts_with[<&lb>hopper]> {
        - determine true
        }
      }
    - determine false

# TODO:

# proc check locked (block, player)

# world: inventory move event -> check hopper
# world: redstone event -> check door
# world: block click event -> check clicking a protectable thing - also manage iron doors/double doors
# world: sign change -> color [lock] signs and [more users]
# world: physics -> prevent sign from falling off
# world: physics -> prevent trap doors from breaking
# world: block break -> prevent breaking locked signs
# world: block place -> show help message

# command: lock cmd -> line edit, 'fix'



