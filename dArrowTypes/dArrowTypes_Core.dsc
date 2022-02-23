# |--------------------------------------
# | D E N I Z E N   A R R O W   T Y P E S
# |
# | dArrowTypes: Custom arrow types to
# | maximize the fun on your surival
# | server!
# | -------------------------------------
#
# @authors mcmonkey
# @version 0.1
# @denizen-version 0.9.7
# @denizen-build 1597
# @date 2015-07-27
#
# @recommended dEssentials https://github.com/mcmonkey4eva/DenizenScripts/tree/master/dEssentials
# @recommended dWorldEditor http://mcmonkey.org/denizen/repo/entry/22
# @recommended dRegions http://mcmonkey.org/denizen/repo/entry/23
# @recommended dSentry http://mcmonkey.org/denizen/repo/entry/0
#
# Installation:
# Just drop it in your scripts folder and reload :D
#
# Usage:
# Craft arrows and bows in all sorts of fancy ways. (Full details / webpage coming soon).
#
# ------------------------------------------------------------------------------

darrowtypes_core_world:
    type: world
    events:
        on player shoots bow:
        - define strength <context.bow.script.data_key[dat_settings.strength]||1>
        - define bombs <context.bow.script.data_key[dat_settings.bombs]||false>
        - define arrow <proc[darrowtypes_determine_item_procedure].context[<context.entity.inventory>|<[strength]>|<[bombs]>]>
        # TODO: If in creative, assume a standard arrow
        - if <[arrow]> == null:
          - determine passively cancelled
          - if <context.entity.is_player>:
            - narrate "<&c>Your bow can't hold the weight of any of your arrows!" targets:<context.entity>
            - wait 1t
            - inventory update d:<context.entity.inventory> stop
        - define critical <context.projectile.critical>
        - define arrow_weight <[arrow].script.data_key[dat_settings.weight]||1>
        - define new_force <context.force.mul[<[strength]>].div[<[arrow_weight]>]>
        - if <[new_force]> > 9.0:
          - define new_force 9.0
        - shoot arrow[critical=<[critical]>] origin:<context.entity> speed:<[new_force]> shooter:<context.entity> save:myarrow
        - if <[arrow].script.data_key[dat_settings.impact_script_task]||null> != null:
          - flag <entry[myarrow].shot_entities.get[1]> dat
          - flag <entry[myarrow].shot_entities.get[1]> impact_script:<[arrow].script.data_key[dat_settings.impact_script_task]||null>
          - flag <entry[myarrow].shot_entities.get[1]> impact_script_defs:<[arrow].script.data_key[dat_settings.impact_script_defs]||li@>
        - else:
          - announce "<[arrow].script> -<&gt> <[arrow].list_keys[dat_settings]>"
        # TODO: Don't take arrow if in creative
        - take <[arrow]> quantity:1 from:<context.entity.inventory>
        - define new_dura <context.bow.durability.add[1]>
        - define slot <context.entity.inventory.find[<context.bow>]>
        # TODO: Don't take bow if in creative
        - take <context.bow> from:<context.entity.inventory> qty:1
        - if <[new_dura]> < <context.bow.material.max_durability>:
          - adjust <context.bow> durability:<[new_dura]> save:new_bow
          - give <entry[new_bow].result> qty:1 to:<context.entity.inventory> slot:<[slot]>
        - determine cancelled
        on projectile hits block:
        - if !<context.projectile.has_flag[dat]>:
          - stop
        - if <context.projectile.has_flag[impact_script]>:
          - define defs li@<context.projectile>|<context.projectile.location>
          - run s@<context.projectile.flag[impact_script]> def:<[defs].include[<context.projectile.flag[impact_script_defs]>]>

darrowtypes_determine_item_procedure:
    type: procedure
    definitions: inventory|strength|bombs
    script:
    # TODO: Quiver
    - foreach <[inventory].list_contents>:
      - if <[value].material.name> == arrow && <[value].script.data_key[dat_settings.weight]||1> <= <[strength]>:
        - if <[bombs]> || !<[value].script.data_key[dat_settings.is_bomb]||false>:
          - determine <[value]>
    - determine null

