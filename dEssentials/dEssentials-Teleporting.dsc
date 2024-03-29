# dEssentials: Things a servers needs in one easy package!
# --- TELEPORTING: Commands related to teleportation.
# See dEssentials-Core.yml for information

dessentials_command_spawn:
    type: command
    debug: false
    name: spawn
    description: Teleports you to the current world's spawn point.
    usage: /spawn
    permission: denizen.essentials.user.spawn
    script:
    - if <context.server>:
      - narrate "<&c>This command is for players only."
      - stop
    - teleport <player> <player.world.spawn_location>

dessentials_command_setspawn:
    type: command
    debug: false
    name: setspawn
    description: Sets the current world's spawn point to your location.
    usage: /setspawn
    permission: denizen.essentials.admin.setspawn
    script:
    - if <context.server>:
      - narrate "<&c>This command is for players only."
      - stop
    - adjust <player.world> spawn_location:<player.location>
    - narrate "<&2>Spawn location in <&b><player.world.name> <&2>set to <&b><player.location.simple.replace[,<player.world.name>]><&2>."

dessentials_command_setwarp:
    type: command
    debug: false
    name: setwarp
    description: Sets a teleport point at your current location.
    usage: /setwarp <&lt>name<&gt>
    permission: denizen.essentials.admin.setwarp
    script:
    - if <context.server>:
      - narrate "<&c>This command is for players only."
      - stop
    - if <context.args.size> != 1:
      - narrate "<&c>/setwarp <&lt>name<&gt>"
      - stop
    - if <context.args.get[1].is[!=].to[<context.args.get[1].escaped>]>:
      - narrate "<&c>Simple (alphanumeric) warp names only please."
      - stop
    - define existing <server.flag[dessentials.warps.<context.args.get[1]>]||null>
    - if <[existing]> != null:
      - narrate "<&c>Warning<&co> Override existing warp (at location<&co> <&b><[existing].simple><&c>)"
    - flag server dessentials.warps.<context.args.get[1]>:<player.location>
    - narrate "<&2>Set warp <&b><context.args.get[1]><&2> at <&b><player.location.simple><&2>!"

dessentials_command_warp:
    type: command
    debug: false
    name: warp
    description: Warps to a given teleport point, or shows a list.
    usage: /warp [name]
    permission: denizen.essentials.user.warp
    script:
    - if <context.server>:
      - narrate "<&c>This command is for players only. (Coming soon: /warp [name] [player])"
      - stop
    - if <context.args.size> != 1:
      # TODO: Warp list!
      - narrate "Warp list coming soon!"
      - stop
    - if <context.args.get[1].is[!=].to[<context.args.get[1].escaped>]>:
      - narrate "<&c>Simple (alphanumeric) warp names only please."
      - stop
    - define existing <server.flag[dessentials.warps.<context.args.get[1]>]||null>
    - if <[existing]> == null:
      - narrate "<&c>Unknown warp name."
      - stop
    # TODO: Delay option, price option
    - narrate "<&6>Teleporting..."
    - teleport <player> <[existing]>
