# +---------------
# |
# | d S e n t r y
# |
# | Sentry rescripted in Denizen!
#
# @author mcmonkey
# @date 2015 / 03 / 07
# @build 1568
# @version 0.7.2
#
# Installation:
# Just copy the script to your scripts folder and /denizen reload scripts
#
# Usage:
# Create NPCs as normal, and use the /dsentry commands to upgrade them.
# Example NPC setup path:
# /npc create JoeTheKiller       # Create and spawn the NPC
# /dsentry create                # Turn it into a dSentry
# /ex equip <npc> hand:bow       # Give the dSentry a bow
# # The dSentry is now a complete and working bowguard, targetting monsters by default
# # Feel free to adjust the targets to your liking, or any other setting you desire.
#
#
# ---------------------------- END HEADER ----------------------------

dsentry_equipment_values:
    type: data
    armor:
      air:
        helmet: 0
        chestplate: 0
        leggings: 0
        boots: 0
        air: 0
      leather:
        helmet: 0.04
        chestplate: 0.12
        leggings: 0.08
        boots: 0.04
      gold:
        helmet: 0.08
        chestplate: 0.20
        leggings: 0.12
        boots: 0.04
      chainmail:
        helmet: 0.08
        chestplate: 0.20
        leggings: 0.16
        boots: 0.04
      iron:
        helmet: 0.08
        chestplate: 0.24
        leggings: 0.20
        boots: 0.08
      diamond:
        helmet: 0.12
        chestplate: 0.32
        leggings: 0.24
        boots: 0.12

dsentry_world_handler:
    type: world
    debug: false
    events:
        on server start:
        - inject locally "events.on reload scripts"
        on reload scripts:
        - if <yaml.list> !contains dsentry_saves:
          - if <server.has_file[dsentry_saves.yml]>:
            - yaml load:dsentry_saves.yml id:dsentry_saves
          - else:
            - yaml create id:dsentry_saves
        - define queues <util.queues.filter[starts_with[dsentry_task_logic]]>
        - foreach <[queues]>:
          - queue <[value]> stop
        - wait 5s
        - run dsentry_task_logic delay:10t
        - foreach <server.npcs_flagged[dsentry.is_dsentry]>:
          - if <[value].is_spawned>:
            - vulnerable npc:<[value]>
            - health <[value].flag[dsentry.health]> npc:<[value]>

        on npc spawns:
        - if !<npc.has_flag[dsentry.is_dsentry]> queue clear
        - vulnerable
        - health <npc.flag[dsentry.health]>
        - heal <npc>

        on player damaged by player:
        - foreach <server.npcs_flagged[dsentry.is_dsentry]>:
          - if !<[value].is_spawned> || <[value].flag[dsentry.target]||null> != null :
            - foreach next
          - if <[value].flag[dsentry.eventtargets].as_list||<list>> !contains PvP:
            - foreach next
          - if <[value].location.world.name> != <context.damager.location.world.name>:
            - foreach next
          - if <[value].location.distance[<context.damager.location>]> < <[value].flag[dsentry.range]>:
            - flag <[value]> dsentry.target:<context.damager>

        on entity damaged by player:
        - if <context.entity.is_player> queue clear
        - if <context.entity.is_npc> queue clear
        - foreach <server.npcs_flagged[dsentry.is_dsentry]>:
          - if !<[value].is_spawned> || <[value].flag[dsentry.target]||null> != null:
            - foreach next
          - if <[value].flag[dsentry.eventtargets].as_list||<list>> !contains PvE:
            - foreach next
          - if <[value].location.world.name> != <context.damager.location.world.name>:
            - foreach next
          - if <[value].location.distance[<context.damager.location>]> < <[value].flag[dsentry.range]>:
            - flag <[value]> dsentry.target:<context.damager>

        on npc damaged by player:
        - if <npc.has_flag[dsentry.is_dsentry]> flag <context.entity> dsentry.target:<context.damager>

        # TODO: Better way to prevent accidental damage
        #on npc damaged by npc:
        #- if <context.entity.as_npc.flag[dsentry.is_dsentry]||false> && <context.damager.as_npc.flag[dsentry.is_dsentry]||false> determine cancelled

        # TODO: calculate NPC armor properly
        on npc damaged:
        - if !<context.entity.has_flag[dsentry.is_dsentry]>:
          - stop
        - define armor <proc[dsentry_proc_calculatearmor]> npc:<context.entity>
        - determine <element[1].sub[<[armor]>].mul[<context.damage>]>

        on npc damages entity:
        - if !<context.damager.as_npc.has_flag[dsentry.is_dsentry]>:
          - stop
        - determine <proc[dsentry_proc_calculatedamage]> npc:<context.damager.as_npc>

dsentry_command_handler:
    type: command
    name: dsentry
    debug: false
    aliases:
    - ds
    description: Control Denizen-powered guard NPCs.
    usage: /dsentry help
    permission: dsentry.command
    script:
    - if <context.server>:
      - define mynpc <server.selected_npc>
    - else:
      - define mynpc <player.selected_npc>
    - if <[mynpc]> == null && <context.args.get[1].length||0> != 0:
      - narrate "<&6>You do not have an NPC selected!"
      - stop
    - if !<[mynpc].has_flag[dsentry.is_dsentry]> && <context.args.get[1].length||0> != 0 && !<context.args.get[1].is[==].to[create]||false>:
      - narrate "<&6>Your selected NPC is not a dSentry!"
      - stop
    - define arg1 <context.args.get[1].escaped||null>
    - define argList <list[create|save|range|followrange|speed|attackrate|damage|add|remove|info|guard|armor|health]>
    - if <[argList].contains[<[arg1]>]>:
      - inject locally dsentry_command_<[arg1]>
    - else:
      - narrate "<&6>/dSentry create [save-type]"
      - narrate "<&6>/dSentry save <&lt>save-type<&gt>"
      - narrate "<&6>/dSentry range <&lt>range<&gt>"
      - narrate "<&6>/dSentry followrange <&lt>range<&gt>"
      - narrate "<&6>/dSentry speed <&lt>speed<&gt>"
      - narrate "<&6>/dSentry damage <&lt>damage<&gt>"
      - narrate "<&6>/dSentry attackrate <&lt>attackrate<&gt>"
      - narrate "<&6>/dSentry health <&lt>max-health-amount<&gt>"
      - narrate "<&6>/dSentry armor <&lt>armor-rating<&gt>"
      - narrate "<&6>/dSentry add <&lt>target<&gt>"
      - narrate "<&6>/dSentry remove <&lt>target<&gt>"
      - narrate "<&6>/dSentry guard [player-name]"
      - narrate "<&6>/dSentry info"

    dsentry_command_info:
    - narrate "<&6>Your selected NPC <&2>is<&6> a dSentry with stats<&co>"
    - narrate "<&6>Range<&co> <&b><[mynpc].flag[dsentry.range]>"
    - narrate "<&6>Damage<&co> <&b><[mynpc].flag[dsentry.damage]>"
    - narrate "<&6>Health<&co> <&b><npc.health><&f>/<&b><[mynpc].flag[dsentry.health]>"
    - if <[mynpc].flag[dsentry.armor]> == -1:
      - define armor <proc[dsentry_proc_calculatearmor]>
      - narrate "<&6>Armor Rating<&co> <&b><[armor].mul[100]><&pc> (Calculated)"
    - else:
      - narrate "<&6>Armor Rating<&co> <&b><[mynpc].flag[dsentry.armor].mul[100]><&pc> (User Defined)"
    - narrate "<&6>Walk speed<&co> <&b><[mynpc].flag[dsentry.walkspeed]>"
    - narrate "<&6>Attack rate<&co> <&b><[mynpc].flag[dsentry.attackrate]>"
    - if <[mynpc].flag[dsentry.flagtargets].size||0> == 0:
      - narrate "<&6>Targets<&co> <&b><[mynpc].flag[dsentry.targets].formatted||None>"
    - else:
      - narrate "<&6>Targets<&co> <&b><[mynpc].flag[dsentry.targets].formatted||None><&6>, or players flagged <&b><[mynpc].flag[dsentry.flagtargets].formatted||None>"
    # added a line to show who dSentry is guarding
    - if <[mynpc].has_flag[dsentry.follow_target]>:
      - narrate "<&6>Currently Guarding<&co> <&b><[mynpc].flag[dsentry.follow_target].as_entity.name||null>"
    dsentry_command_guard:
    - if <context.args.get[2].is[==].to[guard]||true>:
      - flag <[mynpc]> dsentry.follow_target:!
      - narrate "<&c>Guarding nothing."
      - stop
    - if <player[<context.args.get[2].escaped>].exists>:
      - define player <player[<context.args.get[2].escaped>]||null>
      - if <[player]> == null:
        - narrate "<&c>Unknown player or npc."
        - stop
      - flag <[mynpc]> dsentry.follow_target:<[player]>
      - narrate "<&c>Guarding <&b><[player].name><&c>!"
    - else if <[<context.args.get[2].escaped>].exists>:
      - define npc <npc[<context.args.get[2].escaped>]||null>
      - if <[npc]> == null:
        - narrate "<&c>Unknown player or npc."
        - stop
      - flag <[mynpc]> dsentry.follow_target:<[npc]>
      - narrate "<&c>Guarding <&b><[npc].name><&c>!"
    - else:
      - narrate "<&c>Unknown player or npc."
      - stop

    dsentry_command_add:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry add <&lt>target<&gt>"
      - narrate "<&6>Target = an entity type, EG creeper or pig"
      - narrate "<&6>You can also do flagged:FlagName"
      - narrate "<&6>or event:PvP, or event:PvE"
      - stop
    # section deals with adding flag targets
    - if <context.args.get[2].starts_with[flagged<&co>]>:
      - if <[mynpc].flag[dsentry.flagtargets].contains[<context.args.get[2].replace[flagged<&co>]>]||false>:
        - narrate "<&6>That flag target is already set."
        - stop
      - flag <[mynpc]> dsentry.flagtargets:->:<context.args.get[2].replace[flagged<&co>]>
      - narrate "<&6>Flag target added."
      - stop
    # section deals with adding event targets
    - if <context.args.get[2].starts_with[event<&co>]>:
      - if <[mynpc].flag[dsentry.eventtargets].contains[<context.args.get[2].replace[event<&co>]>]>:
        - narrate "<&6>That event target is already set."
        - stop
      - if 'PvP|PvE' !contains <context.args.get[2].replace[event<&co>]>:
        - narrate "<&6>dSentry only accepts PvP or PvE as event targets"
        - stop
      - flag <[mynpc]> dsentry.eventtargets:->:<context.args.get[2].replace[event<&co>]>
      - narrate "<&6>Event target added."
      - stop
    # section deals with adding entity type targets
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That target doesn't look like a proper entity type."
      - stop
    - if <[mynpc].flag[dsentry.targets].contains[<context.args.get[2]>]||false>:
      - narrate "<&6>That target is already set."
      - stop
    - flag <[mynpc]> dsentry.targets:->:<context.args.get[2]>
    - if <[mynpc].flag[dsentry.targets].contains[none]> flag <[mynpc]> dsentry.targets:<-:none
    - narrate "<&6>Added target."

    dsentry_command_remove:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry remove <&lt>target<&gt>"
      - narrate "<&6>Target = an entity type, EG creeper or pig"
      - narrate "<&6>You can also do flagged:FlagName"
      - narrate "<&6>or event:PvP, or event:PvE"
      - stop
    # section deals with removing flag targets
    - if <context.args.get[2].starts_with[flagged<&co>]>:
      - if <context.args.get[2].contains[clearall]||false>:
        - flag <[mynpc]> dsentry.flagtargets:!
        - narrate "<&6>All flag targets cleared."
        - stop
      - if !<[mynpc].flag[dsentry.flagtargets].contains[<context.args.get[2].replace[flagged<&co>]>]||false>:
        - narrate "<&6>That flag target isn't set."
        - stop
      - flag <[mynpc]> dsentry.flagtargets:<-:<context.args.get[2].replace[flagged<&co>]>
      - narrate "<&6>Flag target removed."
      - stop
    # section deals with removing event targets
    - if <context.args.get[2].starts_with[event<&co>]>:
      - if <context.args.get[2].contains[clearall]>:
        - flag <[mynpc]> dsentry.eventtargets:!
        - narrate "<&6>All event targets cleared."
        - stop
      - if !<[mynpc].flag[dsentry.eventtargets].contains[<context.args.get[2].replace[event<&co>]>]>:
        - narrate "<&6>That event target isn't set."
        - stop
      - flag <[mynpc]> dsentry.eventtargets:<-:<context.args.get[2].replace[event<&co>]>
      - narrate "<&6>Event target removed."
      - stop
    # section deals with removing entity targets
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That target doesn't look like a proper entity type."
      - stop
    - if <context.args.get[2].contains[clearall]>:
      # flag set to 'none' to prevent console spam of "no targets set message"
      - flag <[mynpc]> dsentry.targets:none
      - narrate "<&6>All entity type targets cleared."     
      - stop
    - if !<[mynpc].flag[dsentry.targets].contains[<context.args.get[2]>]||false>:
      - narrate "<&6>That target isn't set."
      - stop
    - flag <[mynpc]> dsentry.targets:<-:<context.args.get[2]>
    - narrate "<&6>Removed target."

    dsentry_command_range:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry range <&lt>range<&gt>"
      - narrate "<&6>Range = a number representing how far away (in blocks) the dSentry can attack targets at"
      - stop
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That range value doesn't look like a proper number."
      - stop
    - if !<context.args.get[2].is[matches].to[integer]>:
      - narrate "<&6>That range value doesn't look like a proper number."
      - stop
    - flag <[mynpc]> dsentry.range:<context.args.get[2]>
    - narrate "<&6>Range set."

    dsentry_command_followrange:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry followrange <&lt>range<&gt>"
      - narrate "<&6>Range = a number representing how far away (in blocks) the dSentry can follow players at"
      - stop
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That range value doesn't look like a proper number."
      - stop
    - if !<context.args.get[2].is[matches].to[integer]>:
      - narrate "<&6>That range value doesn't look like a proper number."
      - stop
    - flag <[mynpc]> dsentry.follow_range:<context.args.get[2]>
    - narrate "<&6>Follow range set."

    dsentry_command_damage:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry damage <&lt>damage<&gt>"
      - narrate "<&6>Damage = a number representing how many hearts of damage the NPC deals when it attacks"
      - stop
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That damage value doesn't look like a proper number."
      - stop
    - if !<context.args.get[2].is[matches].to[integer]>:
      - narrate "<&6>That damage value doesn't look like a proper number."
      - stop
    - flag <[mynpc]> dsentry.damage:<context.args.get[2]>
    - narrate "<&6>Damage set."

    dsentry_command_armor:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry armor <&lt>armor<&gt>"
      - narrate "<&6>Armor = what percentage of damage to take away"
      - stop
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That armor value doesn't look like a proper number."
      - stop
    - if !<context.args.get[2].is[matches].to[decimal]>:
      - narrate "<&6>That armor value doesn't look like a proper number."
      - stop
    - flag <[mynpc]> dsentry.armor:<context.args.get[2].div[100]>
    - narrate "<&6>Armor set."

    dsentry_command_health:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry health <&lt>max-health-amount<&gt>"
      - stop
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That health value doesn't look like a proper number."
      - stop
    - if !<context.args.get[2].is[matches].to[integer]>:
      - narrate "<&6>That health value doesn't look like a proper number."
      - stop
    - flag <[mynpc]> dsentry.health:<context.args.get[2]>
    - health npc:<[mynpc]> <[mynpc].flag[dsentry.health]>
    - narrate "<&6>Health set."

    dsentry_command_speed:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry speed <&lt>speed<&gt>"
      - narrate "<&6>Speed = a number representing how fast the NPC should walk while attacking"
      - stop
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That speed value doesn't look like a proper number."
      - stop
    - if !<context.args.get[2].is[matches].to[integer]>:
      - narrate "<&6>That speed value doesn't look like a proper number."
      - stop
    - flag <[mynpc]> dsentry.walkspeed:<context.args.get[2]>
    - narrate "<&6>Speed set."

    dsentry_command_attackrate:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry attackrate <&lt>attackrate<&gt>"
      - narrate "<&6>AttackRate = a number representing how many ticks should pass between an NPC's attacks"
      - narrate "<&6>The minimum is 10. All higher values must be multiples of 10."
      - stop
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That attackrate value doesn't look like a proper number."
      - stop
    - if !<context.args.get[2].is[matches].to[integer]>:
      - narrate "<&6>That attackrate value doesn't look like a proper number."
      - stop
    - flag <[mynpc]> dsentry.attackrate:<context.args.get[2]>
    - flag <[mynpc]> dsentry.attackping:0
    - narrate "<&6>AttackRate set."

    dsentry_command_save:
    - if <context.args.get[2].is[==].to[null]||true>:
      - narrate "<&6>/dSentry save <&lt>save-type<&gt>"
      - narrate "<&6>Save-type = a name that can be used to recreate the dSentry with later"
      - stop
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That save name looks potentially problematic."
      - stop
    - yaml write:dsentry.<context.args.get[2]>.valid value:true id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.range value:<[mynpc].flag[dsentry.range]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.follow_range value:<[mynpc].flag[dsentry.follow_range]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.follow_target value:<[mynpc].flag[dsentry.follow_target]||null> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.attackrate value:<[mynpc].flag[dsentry.attackrate]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.walkspeed value:<[mynpc].flag[dsentry.walkspeed]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.damage value:<[mynpc].flag[dsentry.damage]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.armor value:<[mynpc].flag[dsentry.armor]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.health value:<[mynpc].flag[dsentry.health]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.targets value:<[mynpc].flag[dsentry.targets].as_list||<list>> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.flagtargets value:<[mynpc].flag[dsentry.flagtargets].as_list||<list>> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.eventtargets value:<[mynpc].flag[dsentry.eventtargets].as_list||<list>> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.hand value:<[mynpc].item_in_hand> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.helmet value:<[mynpc].equipment_map.get[helmet]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.chestplate value:<[mynpc].equipment_map.get[chestplate]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.leggings value:<[mynpc].equipment_map.get[leggings]> id:dsentry_saves
    - yaml write:dsentry.<context.args.get[2]>.boots value:<[mynpc].equipment_map.get[boots]> id:dsentry_saves
    - yaml savefile:dsentry_saves.yml id:dsentry_saves
    - narrate "<&6>dSentry type saved!"

    dsentry_command_create:
    - if <context.args.get[2].is[==].to[null]||true>:
      - flag <[mynpc]> dsentry.range:15
      - flag <[mynpc]> dsentry.follow_range:3
      - flag <[mynpc]> dsentry.follow_target:!
      - flag <[mynpc]> dsentry.walkspeed:1
      - flag <[mynpc]> dsentry.attackrate:30
      - flag <[mynpc]> dsentry.attackping:0
      - flag <[mynpc]> dsentry.armor:-1
      - flag <[mynpc]> dsentry.health:20
      - flag <[mynpc]> dsentry.damage:2
      - flag <[mynpc]> dsentry.targets:!
      - flag <[mynpc]> dsentry.targets:|:zombie|creeper|spider|skeleton|witch
      - flag <[mynpc]> dsentry.flagtargets:!
      - flag <[mynpc]> dsentry.eventtargets:!
      - adjust <[mynpc]> teleport_on_stuck:true
      - flag <[mynpc]> dsentry.is_dsentry
      - adjust <[mynpc]> teleport_on_stuck:false
      - narrate "<&6>NPC turned into a default dSentry."
      - stop
    - if !<context.args.get[2].is[==].to[<context.args.get[2].escaped>]>:
      - narrate "<&6>That save name looks potentially problematic."
      - stop
    - define base dsentry.<context.args.get[2]>.
    - if <yaml[dsentry_saves].read[<[base]>valid]||null> != true:
      - narrate "<&6>There are no saves by that name."
      - stop
    - equip <[mynpc]> hand:<yaml[dsentry_saves].read[<[base]>hand]> head:<yaml[dsentry_saves].read[<[base]>helmet]> chest:<yaml[dsentry_saves].read[<[base]>chestplate]> legs:<yaml[dsentry_saves].read[<[base]>leggings]> boots:<yaml[dsentry_saves].read[<[base]>boots]>
    - flag <[mynpc]> dsentry.follow_range:<yaml[dsentry_saves].read[<[base]>follow_range]>
    - flag <[mynpc]> dsentry.follow_target:<yaml[dsentry_saves].read[<[base]>follow_target]>
    - flag <[mynpc]> dsentry.range:<yaml[dsentry_saves].read[<[base]>range]>
    - flag <[mynpc]> dsentry.walkspeed:<yaml[dsentry_saves].read[<[base]>walkspeed]>
    - flag <[mynpc]> dsentry.attackrate:<yaml[dsentry_saves].read[<[base]>attackrate]>
    - flag <[mynpc]> dsentry.attackping:0
    - flag <[mynpc]> dsentry.damage:<yaml[dsentry_saves].read[<[base]>damage]>
    - flag <[mynpc]> dsentry.armor:<yaml[dsentry_saves].read[<[base]>armor]>
    - flag <[mynpc]> dsentry.health:<yaml[dsentry_saves].read[<[base]>health]>
    - flag <[mynpc]> dsentry.targets:!
    - flag <[mynpc]> dsentry.targets:|:<yaml[dsentry_saves].read[<[base]>targets]>
    - flag <[mynpc]> dsentry.flagtargets:!
    - flag <[mynpc]> dsentry.flagtargets:|:<yaml[dsentry_saves].read[<[base]>flagtargets]>
    - flag <[mynpc]> dsentry.eventtargets:!
    - flag <[mynpc]> dsentry.eventtargets:|:<yaml[dsentry_saves].read[<[base]>eventtargets]>
    - flag <[mynpc]> dsentry.is_dsentry
    - narrate "<&6>NPC turned into a custom dSentry."

# Runs repeatedly as the dSentry logic loop
dsentry_task_logic:
    type: task
    debug: false
    script:
    - while true:
      - foreach <server.npcs_flagged[dsentry.is_dsentry]>:
        - if <[value].is_spawned>:
          - run dsentry_task_attack npc:<[value]> instantly
          - if <[value].flag[dsentry.target]||null> == null:
            - resume waypoints npc:<[value]>
      - wait 10t

# Chooses a nearby target
dsentry_proc_picktarget:
    type: procedure
    debug: false
    script:
    - if <npc.flag[dsentry.target]||null> != null:
      - if <npc.flag[dsentry.target].as_entity.is_spawned||false>:
        - if <npc.location.distance[<npc.flag[dsentry.target].as_entity.location>]> < <npc.flag[dsentry.range]>:
          - if <npc.can_see[<npc.flag[dsentry.target]>]>:
            - determine <npc.flag[dsentry.target]>
    - if <npc.flag[dsentry.targets].size||0> == 0:
      - announce to_console "<&6>NPC <npc.id> is marked as a dSentry but does not have a targets list!"
      - stop
    - define entities <npc.location.find_entities[<npc.flag[dsentry.targets]>|player].within[<npc.flag[dsentry.range]>].exclude[<npc>]>
    - define entity null
    - foreach <[entities]>:
      - if <[value].is_npc>:
        - define entities <[entities].exclude[<[value]>]>
    - foreach <[entities]>:
      - if <[value].is_player>:
        - define playrar <[value]>
        - define TEMP_PLAYER_PASS <npc.flag[dsentry.targets].contains[player]||false>
        - foreach <npc.flag[dsentry.flagtargets].as_list||<list>>:
          - if <[playrar].flag[<[value]>]||null> != null:
            - define TEMP_PLAYER_PASS true
        - if <[playrar].gamemode> == CREATIVE:
          - define TEMP_PLAYER_PASS false
        - if !<[TEMP_PLAYER_PASS]>:
          - define entities <[entities].exclude[<[playrar]>]>
    - foreach <[entities]>:
      - if <npc.can_see[<[value]>]>:
        - define entity <[value]>
        - foreach stop
    - determine <[entity]||null>

# Makes a dSentry NPC attack the target
dsentry_task_attack:
    type: task
    debug: false
    script:
    - flag npc dsentry.attackping:<npc.flag[dsentry.attackping].add[10]||0>
    - if <npc.flag[dsentry.attackping]> >= <npc.flag[dsentry.attackrate]>:
      - flag npc dsentry.attackping:0
    - else:
      - stop
    - if <npc.flag[dsentry.target]||null> == null:
      - flag npc dsentry.target:<proc[dsentry_proc_picktarget]>
    - else:
      - if !<entity[<npc.flag[dsentry.target]>].is_spawned||false> || !<npc.can_see[<npc.flag[dsentry.target]>]||false>:
        - flag npc dsentry.target:<proc[dsentry_proc_picktarget]>
    - define valid false
    - if <npc.flag[dsentry.follow_target].is_player||false>:
      - if <npc.flag[dsentry.follow_target].as_player.is_online||false> define valid true
    - else if <npc.flag[dsentry.follow_target].is_npc||false>:
        - if <npc.flag[dsentry.follow_target].as_npc.is_spawned||false> define valid true
    - if <[valid]>:
      - if <npc.location.distance[<npc.flag[dsentry.follow_target].as_entity.location>]> > 100:
        - teleport <npc> <npc.flag[dsentry.follow_target].as_entity.location>
      - if <npc.flag[dsentry.target]||null> == null || <npc.item_in_hand.material.name> == bow:
        - if <npc.location.distance[<npc.flag[dsentry.follow_target].as_entity.location>]> > <npc.flag[dsentry.follow_range]>:
          - walk <npc> <npc.flag[dsentry.follow_target].as_entity.location> auto_range radius:<npc.flag[dsentry.follow_range]>
    - if <npc.flag[dsentry.target]||null> == null:
      - if <npc.entity_type> == player animate <npc> animation:stop_use_item
      - stop
    - if <npc.item_in_hand.material.name> != bow:
      - pause waypoints
    - define loc <npc.flag[dsentry.target].as_entity.location.add[0,0.33,0]>
    - look <[loc]>
    - if <npc.item_in_hand.material.name> == bow:
      # TODO: should critical=true be enabled in some cases? (corrupts damage calc)
      - define settings knockback=1
      - if <npc.item_in_hand.enchantments||<list>> contains ARROW_FIRE:
        - define settings <[settings]>;fire_time=1m
      - if <npc.entity_type> == player <npc> animation:stop_use_item
      - shoot arrow[<[settings]>] origin:<npc> destination:<[loc]> speed:50 lead:<npc.flag[dsentry.target].as_entity.velocity> script:dsentry_task_removearrow
      - wait 1t
      - if <npc.entity_type> == player animate <npc> animation:start_use_item
    - else if <npc.location.distance[<[loc]>]> > 3:
      - walk <[loc]> speed:<npc.flag[dsentry.walkspeed]>
    - else:
      - if <npc.entity_type> == player animate <npc> animation:arm_swing
      - hurt <npc.flag[dsentry.target]> <proc[dsentry_proc_calculatedamage]>
      - if <npc.item_in_hand.material.name> != air:
        - if <npc.item_in_hand.enchantments||<list>> contains FIRE_ASPECT:
          - adjust <npc.flag[dsentry.target]> fire_time:10s

dsentry_task_removearrow:
    type: task
    debug: false
    script:
    - if <[hit_entities].is_empty>:
      - remove <[shot_entities]>

dsentry_proc_calculatearmor:
    type: procedure
    debug: false
    script:
    # flag npc armor '-1' to use calculated armor, otherwise, trust the flag value
    - if <npc.flag[dsentry.armor]> >= 0:
      - determine <npc.flag[dsentry.armor]>
    - define total 0
    - foreach helmet|chestplate|leggings|boots:
      - define material <npc.equipment_map.get[<[value]>].material.name.replace[_<[value]>]||air>
      - define total <[total].add[<script[dsentry_equipment_values].data_key[armor.<[material]>.<[value]>]>]>
    - determine <[total]>

dsentry_proc_calculatedamage:
    type: procedure
    debug: false
    script:
    # flag npc damage '-1' to use calculated damage, otherwise, trust the flag value
    - if <npc.flag[dsentry.damage]> >= 0:
      - determine <npc.flag[dsentry.damage]>
    # TODO: calculate damage based on held item
    # TODO: Make the default damage -1
