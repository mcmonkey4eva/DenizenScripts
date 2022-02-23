# dEssentials: Things a servers needs in one easy package!
# --- ITEMS: Commands related to the item system.
# See dEssentials-Core.yml for information

dessentials_command_itemdb:
    type: command
    debug: false
    name: itemdb
    description: Shows information on the held item, or a specified item.
    usage: /itemdb [item]
    permission: denizen.essentials.user.itemdb
    script:
    - if <context.server> && <context.args.size> != 1:
      - narrate "<&c>This command is for players only."
      - narrate "<&c>Available for the server<&co> /itemdb <&lt>item<&gt>"
      - stop
    - define item <player.item_in_hand>
    - if <context.args.size> == 1:
      - define item <item[<context.args.get[1]>]||null>
    - if <[item].is[==].to[null]> || <[item].material.name||null> == null:
      - narrate "<&c>Unknown item."
      - stop
    - narrate "<&6>Item<&f><&co> <&b><[item].material.name>"
    - narrate "<&6>Internal name<&f><&co> <&b><[item].material.name>"
    - narrate "<&6>Full Denizen descriptor<&f><&co> <&b><[item]>"

dessentials_command_item:
    type: command
    debug: false
    name: item
    description: Gives an item.
    usage: /item <&lt>item<&gt>
    permission: denizen.essentials.admin.item
    aliases:
    - i
    script:
    - if <context.server>:
      - narrate "<&c>This command is for players only."
      - stop
    - if <context.args.size> < 1:
      - narrate "<&c>/item <&lt>item<&gt>"
      - stop
    - define item "<item[<context.raw_args>]>"
    - if <[item].material.name||null> == null:
      - narrate "<&c>Unknown item."
      - stop
    - adjust <[item]> quantity:1 save:myitem
    - narrate "<&2>Giving <&b><[item].quantity><&2> of <&b><entry[myitem].result><&2>."
    - give <[item]>

dessentials_command_invsee:
    type: command
    debug: false
    name: invsee
    description: Shows the inventory of another player.
    usage: /invsee <&lt>player<&gt>
    permission: denizen.essentials.admin.invsee
    tab complete:
    - if !<player.has_permission[<script.data_key[permission]>]||<context.server>> queue clear
    - determine <server.players.parse[name]>
    script:
    - if <context.server>:
      - narrate "<&c>This command is for players only!"
      - stop
    - if <context.args.size> != 1:
      - narrate "<&c>/invsee <&lt>player<&gt>"
      - stop
    - define player <server.match_offline_player[<context.args.get[1]>]>
    - if <[player]> == null:
      - narrate "<&c>No player found with name <&b><context.args.get[1]>"
      - stop
    - inventory open d:<[player].inventory>

dessentials_command_endersee:
    type: command
    debug: false
    name: endersee
    description: Shows the enderchest of another player.
    usage: /endersee <&lt>player<&gt>
    permission: denizen.essentials.admin.endersee
    tab complete:
      - if !<player.has_permission[<script.data_key[permission]>]||<context.server>> queue clear
      - determine <server.players.parse[name].filter[starts_with[<context.args.last>]]>
    script:
    - if <context.server>:
      - narrate "<&c>This command is for players only!"
      - stop
    - if <context.args.size> != 1:
      - narrate "<&c>/endersee <&lt>player<&gt>"
      - stop
    - define player <server.match_offline_player[<context.args.get[1]>]>
    - if <[player]> == null:
      - narrate "<&c>No player found with name <&b><context.args.get[1]>"
      - stop
    - inventory open d:<[player].enderchest>

dessentials_command_enchant:
    type: command
    debug: false
    name: enchant
    description: Allows you to enchant the item in hand. Level is required.
    usage: /enchant <&lt>enchantment,level|.../list<&gt>
    permission: denizen.essentials.admin.enchant
    script:
    - if <context.server>:
      - narrate "<&c>This command is for players only!"
      - stop
    - if <context.args.size> != 1:
      - narrate "<&c>/enchant <&lt>enchantment,level|...<&gt>/list"
      - stop
    - define valid <list[ARROW_DAMAGE|ARROW_FIRE|ARROW_INFINITE|ARROW_KNOCKBACK|DAMAGE_ALL|DAMAGE_ANTHROPODSROPODS|DAMAGE_UNDEAD|DEPTH_STRIDER]>
    - define valid <[valid].include[DIG_SPEED|DURABILITY|FIRE_ASPECT|KNOCKBACK|LOOT_BONUS_BLOCKS|LUCK|LURE|OXYGEN|PROTECTION_ENVIRONMENTAL]>
    - define valid <[valid].include[PROTECTION_EXPLOSIONS|PROTECTION_FALL|PROTECTION_FIRE|PROTECTION_PROJECTILE|SILK_TOUCH|THORNS|WATER_WORKER]>
    - if <context.args.get[1]> == list:
      - narrate "<&2>Valid enchantments: <&b><[valid].formatted.replace[, and].with[,].replace[,].with[<&f>,<&b>]><&2>."
      - stop
    - define item <player.item_in_hand>
    - if <[item].material.name> == air:
      - narrate "<&c>Cannot enchant air!"
      - stop
    - define enchantments <context.args.get[1].escaped.split[&pipe]>
    - foreach <[enchantments]>:
      - define enchantment <[value].split[,].get[1]>
      - if !<[valid].contains[<[enchantment]>]>:
        - narrate "<&c>Invalid enchantment <[enchantment]>"
        - stop
      - define level <[value].split[,].get[2]||null>
      - if <[level]> == null || <[level]> < 1:
        - narrate "<&c>Invalid level or none specified."
        - stop
    - adjust <[item]> enchantments:<[enchantments]> save:item
    - inventory set o:<entry[item].result> d:<player.inventory> slot:<player.held_item_slot>
    - define enchantments <entry[item].result.enchantments.with_levels>
    - narrate "<&2>Item is now enchanted with <&b><[enchantments].parse[replace[,].with[: ]].formatted.replace[, and].with[<&2> + <&b>].replace[, ].with[<&2> + <&b>]><&2>"
