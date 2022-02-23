# dEssentials: Things a servers needs in one easy package!
# --- FUN: Commands that are just for fun. You don't need this file.
# See dEssentials-Core.yml for information

dessentials_command_celebrate:
    type: command
    debug: false
    name: celebrate
    description: Launches a celebration show.
    usage: /celebrate
    permission: denizen.essentials.user.celebrate
    script:
    - if <context.server>:
      - narrate "<&c>This command is for players only."
      - stop
    - repeat 15:
      - define x <util.random.decimal[-10].to[10]>
      - define z <util.random.decimal[-10].to[10]>
      - firework <player.location.add[<[x]>,0,<[z]>]> power:1 primary:crandom|random fade:crandom|random random flicker trail
      - if <[value].mod[5]> == 1:
        - wait 1
