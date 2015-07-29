# See dArrowTypes-Core.yml for information

darrowtypes_command:
    type: command
    name: darrowtypes
    usage: /darrowtypes
    description: Helps you take maximum advantage of the dArrowTypes engine!
    permission: darrowtypes.basic
    aliases:
    - dat
    script:
    - if <context.server> {
      - narrate "<&c>This command is intended for players only."
      - queue clear
      }
    - if <context.args.size> == 0 {
      - inject locally show_help
      - queue clear
      }
    - choose <context.args.get[1].escaped>:
      - case "give":
        - narrate "<green>Giving bows..."
        - give i@bow quantity:1
        - give i@darrowtypes_strong_bow quantity:1
        - give i@darrowtypes_very_strong_bow quantity:1
        - give i@darrowtypes_weak_bpg quantity:1
        - give i@darrowtypes_strong_bpg quantity:1
        - give i@darrowtypes_cannon quantity:1
        - narrate "<green>Giving arrows..."
        - give i@arrow quantity:16
        - give i@darrowtypes_light_arrow quantity:16
        - give i@darrowtypes_heavy_arrow quantity:16
        - give i@darrowtypes_small_bomb_arrow quantity:16
        - give i@darrowtypes_large_bomb_arrow quantity:16
      - default:
        - inject locally show_help
    show_help:
    - narrate "<&6>/darrowtypes give  | to give all arrows and bows"

