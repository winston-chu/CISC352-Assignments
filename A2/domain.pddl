(define (domain Dungeon)

    (:requirements
        :typing
        :negative-preconditions
        :conditional-effects
        :equality
    )

    ; Do not modify the types
    (:types
        location colour key corridor
    )

    ; Do not modify the constants
    (:constants
        red yellow green purple rainbow - colour
    )

    ; You may introduce whatever predicates you would like to use
    (:predicates

        ; One predicate given for free!
        (hero-at ?loc - location)
        (connected ?loc ?cor - corridor)       ; Corridor connecting to a room
        (key-loc ?key - key ?loc - location)        ; Key location
        (has-key ?key - key)                        ; Hero is holding a key
        (free-arm)                                    ; Hero is not holding a key
        (locked ?cor - corridor)        ; Corridor is locked
        (locked-col ?col - colour)
        (risky ?cor - corridor)                       ; Corridor collapses after use
        (messy ?loc - location)                     ; Room is messy
        (key-colour ?key - key ?col - colour)       ; Key color
        (has-use ?key - key)                        ; Key has uses left
        (one-use ?key - key)                        ; Key can be used once
        (two-use ?key - key)                        ; Key can be used twice
        (multi-use ?key - key)                      ; Key can be used infinitely
        (dead-key ?key - key)                       ; Key out of uses

        ; IMPLEMENT ME

    )

    ; IMPORTANT: You should not change/add/remove the action names or parameters

    ;Hero can move if the
    ;    - hero is at current location ?from,
    ;    - hero will move to location ?to,
    ;    - corridor ?cor exists between the ?from and ?to locations
    ;    - there isn't a locked door in corridor ?cor
    ;Effects move the hero, and collapse the corridor if it's "risky" (also causing a mess in the ?to location)
    (:action move

        :parameters (?from ?to - location ?cor - corridor)

        :precondition (and

            (hero-at ?from)
            (not (messy ?cor))
            (connected ?to ?cor)
            (connected ?from ?cor)
            (not (locked ?cor))

        )

        :effect (and

            (not (hero-at ?from))
            (hero-at ?to)
            (when (risky ?cor) (messy ?to))

        )
    )

    ;Hero can pick up a key if the
    ;    - hero is at current location ?loc,
    ;    - there is a key ?k at location ?loc,
    ;    - the hero's arm is free,
    ;    - the location is not messy
    ;Effect will have the hero holding the key and their arm no longer being free
    (:action pick-up

        :parameters (?loc - location ?k - key)

        :precondition (and

            (hero-at ?loc)
            (key-loc ?k ?loc)
            (free-arm)
            (not (messy ?loc))

        )

        :effect (and

            (not (key-loc ?k ?loc))
            (has-key ?k)
            (not (free-arm))

        )
    )

    ;Hero can drop a key if the
    ;    - hero is holding a key ?k,
    ;    - the hero is at location ?loc
    ;Effect will be that the hero is no longer holding the key
    (:action drop

        :parameters (?loc - location ?k - key)

        :precondition (and

            (has-key ?k)
            (hero-at ?loc)

        )

        :effect (and

            (not (has-key ?k))
            (key-loc ?k ?loc)
            (free-arm)

        )
    )


    ;Hero can use a key for a corridor if
    ;    - the hero is holding a key ?k,
    ;    - the key still has some uses left,
    ;    - the corridor ?cor is locked with colour ?col,
    ;    - the key ?k is if the right colour ?col,
    ;    - the hero is at location ?loc
    ;    - the corridor is connected to the location ?loc
    ;Effect will be that the corridor is unlocked and the key usage will be updated if necessary
    (:action unlock

        :parameters (?loc - location ?cor - corridor ?col - colour ?k - key)

        :precondition (and

            (has-key ?k)
            (has-use ?k)
            (locked ?cor)
            (locked-col ?col)
            (key-colour ?k ?col)
            (hero-at ?loc)
            (connected ?loc ?cor)

        )

        :effect (and

            (not (locked ?cor))
            (when (one-use ?k) (and (not (one-use ?k)) (not (has-use ?k))))
            (when (two-use ?k) (and (not (two-use ?k)) (one-use ?k)))

        )
    )

    ;Hero can clean a location if
    ;    - the hero is at location ?loc,
    ;    - the location is messy
    ;Effect will be that the location is no longer messy
    (:action clean

        :parameters (?loc - location)

        :precondition (and

            (hero-at ?loc)
            (messy ?loc)

        )

        :effect (and

            (not (messy ?loc))

        )
    )

)
