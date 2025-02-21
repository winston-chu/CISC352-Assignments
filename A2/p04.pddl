(define (problem p4-dungeon)
  (:domain Dungeon)

  ; Come up with your own problem instance (see assignment for details)
  ; NOTE: You _may_ use new objects for this problem only.

  ; Naming convention:
  ; - loc-{i}-{j} refers to the location at the i'th column and j'th row (starting in top left corner)
  ; - c{i}{j}{h}{k} refers to the corridor connecting loc-{i}-{j} and loc-{h}-{k}
  (:objects
    loc-1-1 loc-2-1 loc-3-1 loc-4-1 loc-5-1 loc-6-1 loc-7-1 loc-8-1 - location
    c1121 c2131 c3141 c4151 c5161 c6171 c7181 - corridor
    key1 key2 key3 key4 key5 - key
  )

  (:init

    ; Hero location and carrying status
    (hero-at loc-3-1)
    (free-arm)

    ; Locationg <> Corridor Connections
    (connected loc-1-1 c1121)
    (connected loc-2-1 c1121)
    (connected loc-2-1 c2131)
    (connected loc-3-1 c2131)
    (connected loc-3-1 c3141)
    (connected loc-4-1 c3141)
    (connected loc-4-1 c4151)
    (connected loc-5-1 c4151)
    (connected loc-5-1 c5161)
    (connected loc-6-1 c5161)
    (connected loc-6-1 c6171)
    (connected loc-7-1 c6171)
    (connected loc-7-1 c7181)
    (connected loc-8-1 c7181)

    ; Key locations
    (key-loc key1 loc-1-1)
    (key-loc key2 loc-1-1)
    (key-loc key3 loc-1-1)
    (key-loc key4 loc-1-1)
    (key-loc key5 loc-7-1)

    ; Locked corridors
    (locked c3141)
    (locked-col c3141 purple)
    (locked c4151)
    (locked-col c4151 green)
    (locked c5161)
    (locked-col c5161 yellow)
    (locked c6171)
    (locked-col c6171 red)
    (locked c7181)
    (locked-col c7181 rainbow)

    ; Risky corridors
    (risky c6171)

    ; Key colours
    (key-colour key1 purple)
    (key-colour key2 green)
    (key-colour key3 yellow)
    (key-colour key4 red)
    (key-colour key5 rainbow)

    ; Key usage properties (one use, two use, etc)
    (one-use key1)
    (one-use key2)
    (two-use key3)
    (one-use key5)
    (has-use key1)
    (has-use key2)
    (has-use key3)
    (has-use key4)
    (has-use key5)

  )
  (:goal
    (and
      ; Hero's final location goes here
      (hero-at loc-8-1)
    )
  )

)
