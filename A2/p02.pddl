(define (problem p2-dungeon)
  (:domain Dungeon)

  ; Naming convention:
  ; - loc-{i}-{j} refers to the location at the i'th column and j'th row (starting in top left corner)
  ; - c{i}{j}{h}{k} refers to the corridor connecting loc-{i}-{j} and loc-{h}-{k}
  (:objects
    loc-2-1 loc-1-2 loc-2-2 loc-3-2 loc-4-2 loc-2-3 - location
    key1 key2 key3 key4 - key
    c2122 c1222 c2232 c3242 c2223 - corridor
  )

  (:init

    ; Hero location and carrying status
    (hero-at loc-2-2)
    (free-arm)

    ; Locationg <> Corridor Connections
    (connected loc-2-1 c2122)
    (connected loc-2-2 c2122)
    (connected loc-1-2 c1222)
    (connected loc-2-2 c1222)
    (connected loc-2-2 c2232)
    (connected loc-3-2 c2232)
    (connected loc-3-2 c3242)
    (connected loc-4-2 c3242)
    (connected loc-2-2 c2223)
    (connected loc-2-3 c2223)

    ; Key locations
    (key-loc key1 loc-2-1)
    (key-loc key2 loc-1-2)
    (key-loc key3 loc-2-2)
    (key-loc key4 loc-2-3)

    ; Locked corridors
    (locked c2122)
    (locked-col c2122 purple)
    (locked c1222)
    (locked-col c1222 yellow)
    (locked c2232)
    (locked-col c2232 yellow)
    (locked c2223)
    (locked-col c2223 green)
    (locked c3242)
    (locked-col c3242 rainbow)

    ; Risky corridors (N/A)

    ; Key colours
    (key-colour key1 green)
    (key-colour key2 rainbow)
    (key-colour key3 purple)
    (key-colour key4 yellow)

    ; Key usage properties (one use, two use, etc)
    (two-use key4)
    (one-use key1)
    (one-use key2)
    (one-use key3)
    (has-use key1)
    (has-use key2)
    (has-use key3)
    (has-use key4)

  )
  (:goal
    (and
      ; Hero's final location goes here
      (hero-at loc-4-2)
    )
  )

)
