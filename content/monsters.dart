/// Builder class for defining [Monster] [Breed]s.
class MonsterBuilder extends ContentBuilder {
  Map<String, Breed> build() {
    // $  Creeping Coins
    // a  Arachnid/Scorpion   A  Ancient being
    // b  Giant Bat           B  Bird
    // c  Canine (Dog)        C  Canid (Dog-like humanoid, kobold)
    // d  Dragon              D  Ancient Dragon
    // e  Floating Eye        E  Elemental
    // f  Flying Insect       F  Feline (Cat)
    // g  Ghost               G  Golem
    // h  Humanoids           H  Hybrid
    // i  Insect              I  Goblin / Imp
    // j  Jelly               J  Slime
    // k  Skeleton            K  Kraken/Land Octopus
    // l  Lizard man          L  Lich
    // m  Mold/Mushroom       M  Multi-Headed Hydra
    // n  Naga                N  Demon
    // o  Orc                 O  Ogre
    // p  Human "person"      P  Giant "person"
    // q  Quadruped           Q  End boss ("quest")
    // r  Rodent              R  Reptile/Amphibian
    // s  Slug                S  Snake
    // t  Troglodyte          T  Troll
    // u  Minor Undead        U  Major Undead
    // v  Vine/Plant          V  Vampire
    // w  Worm or Worm Mass   W  Wight/Wraith
    // x  (unused)            X  Xorn/Xaren
    // y  Yeek                Y  Yeti
    // z  Zombie/Mummy        Z  Serpent (snake-like dragon)
    // TODO(bob):
    // - Come up with something better than yeeks for 'y'.
    // - Don't use both 'u' and 'U' for undead?

    arachnids();
    bats();
    birds();
    canines();
    felines();
    humanoids();
    insects();
    imps();
    people();
    rodents();
    slugs();
    snakes();
    worms();
  }

  arachnids() {
    breed('garden spider', darkAqua('a'), [
        attack('bite[s]', 2, Element.POISON)
      ],
      maxHealth: 2, meander: 8,
      flags: 'group'
    );

    breed('brown spider', brown('a'), [
        attack('bite[s]', 3, Element.POISON)
      ],
      maxHealth: 3, meander: 8,
      flags: 'group'
    );

    breed('giant spider', darkBlue('a'), [
        attack('bite[s]', 8, Element.POISON)
      ],
      maxHealth: 12, olfaction: 5, meander: 5
    );
  }

  bats() {
    breed('little brown bat', lightBrown('b'), [
        attack('bite[s]', 3),
      ],
      maxHealth: 3, meander: 6, speed: 2
    );
  }

  birds() {
    breed('crow', darkGray('B'), [
        attack('bite[s]', 4),
      ],
      drop: chanceOf(25, 'Black feather'),
      maxHealth: 4, meander: 4, speed: 2,
      flags: 'group'
    );

    breed('raven', gray('B'), [
        attack('bite[s]', 6),
        attack('claw[s]', 5),
      ],
      drop: hunting('Black feather'),
      maxHealth: 8, meander: 1
    );
  }

  canines() {
    breed('mangy cur', yellow('c'), [
        attack('bite[s]', 4),
      ],
      drop: hunting(chanceOf(70, 'Fur pelt')),
      maxHealth: 7, olfaction: 5, meander: 3,
      flags: 'few'
    );

    breed('wild dog', gray('c'), [
        attack('bite[s]', 5),
      ],
      drop: hunting('Fur pelt'),
      maxHealth: 9, olfaction: 5, meander: 3,
      flags: 'few'
    );
  }

  felines() {
    breed('stray cat', gray('F'), [
        attack('bite[s]', 4),
        attack('scratch[es]', 3),
      ],
      drop: hunting(chanceOf(50, 'Fur pelt')),
      maxHealth: 5, meander: 3, olfaction: 7, speed: 1
    );
  }

  humanoids() {
  }

  insects() {
    breed('giant cockroach', darkBrown('i'), [
        attack('crawl[s] on', 1),
      ],
      drop: hunting('Insect wing'),
      maxHealth: 12, meander: 8, speed: 3
    );
  }

  imps() {
    var spear = graduated(9, [
      'Spear', 'Angon', 'Lance', 'Partisan'
    ]);

    var dirk = graduated(8, [
      'Dirk', 'Dagger', 'Stiletto', 'Rondel', 'Baselard', 'Main-guache'
    ]);

    breed('scurrilous imp', lightRed('I'), [
        attack('scratch[es]', 4),
        insult()
      ],
      maxHealth: 10, meander: 4, speed: 1,
      flags: 'few'
    );

    breed('goblin peon', lightBrown('I'), [
        attack('stab[s]', 4)
      ],
      drop: chanceOf(10, 'Spear'),
      maxHealth: 10, meander: 2,
      flags: 'open-doors'
    );

    breed('goblin warrior', brown('I'), [
        attack('stab[s]', 8)
      ],
      drop: chanceOf(10, 'Spear'),
      maxHealth: 16, meander: 1,
      flags: 'open-doors'
    );
  }

  people() {
    var knife = graduated(8, [
      'Knife', 'Dirk', 'Dagger', 'Stiletto', 'Rondel', 'Baselard', 'Main-guache'
    ]);

    breed('simpering knave', orange('p'), [
        attack('hit[s]', 2),
        attack('stab[s]', 4)
      ],
      drop: [
        chanceOf(20, knife),
        chanceOf(20, 'Cloth Shirt')
      ],
      maxHealth: 6, meander: 3,
      flags: 'open-doors'
    );

    breed('doddering old mage', purple('p'), [
        attack('hit[s]', 3),
        sparkBolt(cost: 16, damage: 8)
      ],
      drop: [
         chanceOf(10, 'Scroll of Sidestepping'),
         chanceOf(7, 'Staff'),
         chanceOf(7, knife),
         chanceOf(7, 'Cloth Shirt'),
         chanceOf(5, 'Robe')
      ],
      maxHealth: 8, meander: 2,
      flags: 'open-doors'
    );

    breed('drunken priest', aqua('p'), [
        attack('hit[s]', 3),
        heal(cost: 30, amount: 8)
      ],
      drop: [
         chanceOf(10, 'Soothing Balm'),
         chanceOf(7, 'Staff'),
         chanceOf(7, 'Cudgel'),
         chanceOf(7, 'Cloth Shirt'),
         chanceOf(5, 'Robe')
      ],
      maxHealth: 9, meander: 4,
      flags: 'open-doors'
    );
  }

  rodents() {
    breed('white mouse', white('r'), [
        attack('bite[s]', 3),
        attack('scratch[es]', 2)
      ],
      maxHealth: 3, olfaction: 2, meander: 4, speed: 1
    );

    breed('sewer rat', darkGray('r'), [
        attack('bite[s]', 3),
        attack('scratch[es]', 2)
      ],
      maxHealth: 5, olfaction: 2, meander: 3, speed: 1,
      flags: 'group'
    );
  }

  slugs() {
    breed('giant slug', green('s'), [
        attack('crawl[s] on', 8),
      ],
      maxHealth: 12, meander: 4, speed: -3
    );
  }

  snakes() {
    breed('tree snake', lightGreen('S'), [
        attack('bite[s]', 8),
      ],
      maxHealth: 12, meander: 3
    );
  }

  worms() {
    breed('earthworm', lightRed('w'), [
        attack('crawl[s] on', 8),
      ],
      maxHealth: 16, meander: 4, speed: -2
    );
  }

  Breed breed(String name, Glyph appearance, List actions, [
      drop, int maxHealth, int olfaction = 0,
      int meander = 0, int speed = 0, String flags]) {

    var attacks = <Attack>[];
    var moves = <Move>[];

    for (final action in actions) {
      if (action is Attack) attacks.add(action);
      if (action is Move) moves.add(action);
    }

    drop = _parseDrop(drop);

    var flagSet;
    if (flags != null) {
      flagSet = new Set<String>.from(flags.split(' '));
    } else {
      flagSet = new Set<String>();
    }

    final breed = new Breed(name, Gender.NEUTER, appearance, attacks, moves,
        drop, maxHealth: maxHealth, olfaction: olfaction, meander: meander,
        speed: speed, flags: flagSet);
    _breeds[name] = breed;
    return breed;
  }

  Move heal([int cost, int amount]) => new HealMove(cost, amount);

  Move sparkBolt([int cost, int damage]) =>
      new BoltMove(cost, new Attack('zaps', damage, Element.LIGHTNING,
          new Noun('the spark')));

  Move insult([int cost = 20]) => new InsultMove(cost);
}
