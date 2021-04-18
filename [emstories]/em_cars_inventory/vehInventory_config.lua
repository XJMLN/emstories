CONFIG_VEHICLES = {
    --Pojazdy Fire Department
    ["ferrara"]={faction=3,department=1,Inventory=
        {
            --['taillight_l']={name="Naciśnij ~INPUT_PICKUP~ aby otworzyć boczną roletę",items={3,4}},
            ['wheel_lr']={dist=3.0,name="Naciśnij ~INPUT_PICKUP~ aby otworzyć boczną roletę",items={1,2,3,4}},
        }
    },
    ['chevy tahoe']={faction=3,department=1,Inventory={
        ['wheel_rr']={dist=1.0,name="Naciśnij ~INPUT_PICKUP~ aby otworzyć boczną roletę",items={1,2,3,4}},
        ['wheel_lr']={dist=1.0,name="Naciśnij ~INPUT_PICKUP~ aby otworzyć boczną roletę",items={1,2,3,4}},
    }},

    --Pojazdy Medical Center
    ["tahoe"]={faction=2,department=2,Inventory={
        ['boot']={dist=1.4,name="Naciśnij ~INPUT_PICKUP~ aby otworzyć bagażnik.",items={3,4,5}},
        
    }},
    ['f750']={faction=2,department=2,Inventory={
        ['door_dside_r']={dist=6.0, name="Naciśnij ~INPUT_PICKUP~ aby otworzyć tylne drzwi.",items={5,6}},
    }}
}