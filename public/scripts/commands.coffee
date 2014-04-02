@help = (term) -> term.echo '''

COMMAND     ARGUMENTS         DESCRIPTION

help        N/A               List of commands

create                        Create anything
            char              Create a new character
            room              Create a new room
            object            Create a new object

edit                          Edit anything
            self              Edit your out-of-character self
            char              Edit a characters
            room              Edit a room

[[;blue;white]Coming soon...]

COMMAND     ARGUMENTS         DESCRIPTION

edit        char, <name>      Edit the character <name>
            room, <code>      Edit room <code>
            object            Edit an object
            object, <code>    Edit object <code>

tutorial    reset             Resets the tutorial
            skip              No more tutorials will be seen

'''