# dEssentials: Things a servers needs in one easy package!
# --- UTILITY: Functionality not contained within a command.
# See dEssentials-Core.yml for information

dessentials_utility_events:
    type: world
    debug: false
    events:
        ## Sign Colors ##
        on player changes sign:
        - if <player.has_permission[denizen.essentials.utility.signcolor]||<player.is_op>> {
          - determine <context.new.replace[regex:&([0-9a-fA-Fk-oK-OrR])].with[<red.substring[1,1]>$1]>
          }
        ## Chat Colors ##
        on player chats:
        - if <player.has_permission[denizen.essentials.utility.chatcolor]||<player.is_op>> {
          - determine <context.message.replace[regex:&([0-9a-fA-Fk-oK-OrR])].with[<red.substring[1,1]>$1]>
          }
