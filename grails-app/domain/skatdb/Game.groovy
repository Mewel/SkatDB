package skatdb

class Game {

	SkatGroup group
	Player player

	/**
	 * bid of 0 = ramsch
	 */
	int bid = 18

	int jacks = 1

	/**
	 * diamond(9)
	 * heart(10)
	 * spade(11)
	 * clubs(12)
	 * grand(24)
	 * nullgame(23)
	 * nullhand(35)
	 * nullouvert(46)
	 * nullhandouvert(59)
	 */
	int gameType = 9

	boolean hand = false

	/**
	 * (default game)
	 * game(1)
	 * schneider(2)
	 * schwarz(3)
	 * --------------
	 * (hand)
	 * game(2)
	 * schneider (3)
	 * schneider_announced(4),
	 * schwarz(5),
	 * schwarz_announced(6),
	 * ouvert(7)
	 * --------------
	 * (ramsch)
	 * game(-1)
	 * jungfer(-2)
	 * durchmarsch(2)
	 */
	int gameLevel = 1

	/**
	 * none(1)
	 * spritze(2)
	 * re(4)
	 * hirsch(8)
	 */
	int announcement = 1

	boolean won = true

	int value = 0;

	Date createDate = new Date()

	Date modifyDate = new Date()

	transient boolean importMode = false

	static constraints = {
		group()
		player()
		bid(inList: [0, 18,	20, 22,	23,	24,	27,	30,	33,	35,	36,	40,	44,	45,	46,	48,	50,	54,	55,	59,	60,	63,	66,
				70,	72,	77,	80,	81,	84,	88,	90,	96,	99,	100, 108, 110, 117, 120, 121, 126, 130, 132, 135,
				140, 143, 144, 150, 153, 154, 156, 160, 162, 165, 168, 170, 176, 180, 187, 192, 198, 204,
				216, 240, 264])
		jacks()
		hand()
		gameType(inList: [9, 10, 11, 12, 24, 23, 35, 46, 59])
		gameLevel(inList: [-2, -1, 1, 2, 3, 4, 5, 6, 7])
		announcement(inList: [1, 2, 4, 8])
		won()
		value()
	}

	def beforeInsert() {
		value = calcValue()
	}

	def beforeUpdate() {
		modifyDate = new Date()
		value = calcValue()
	}

	def afterInsert() {
		if(importMode) {
			return;
		}
		if(group instanceof Tournament) {
			group.addGame(this)
		}
	}

	int calcValue() {
		int newValue = 0
		if(bid == 0) {
			// ramsch -> we use the jacks as value
			newValue = jacks * gameLevel;
			won = gameLevel > 0;
			jacks = 1;
		} else {
			// normal game
			if(isNullGame()) {
				newValue = gameType
			} else {
				newValue = gameType * (jacks + gameLevel)
			}
			newValue *= announcement;
			if(!won) {
				newValue = newValue * -2;
			}
		}
		// tournament
		if(group instanceof Tournament) {
			newValue += won ? 50 : -100
		}
		return newValue;
	}

	boolean isNullGame() {
		return gameType == 23 || gameType == 35 || gameType == 46 || gameType == 59
	}

	String toString () {
		return "["+
		"group: " + group.name +
		", player: " + player.name +
		", bid: " + bid +
		", jacks: " + jacks +
		", gameType: " + gameType +
		", hand: " + hand +
		", gameLevel: " + gameLevel +
		", announcement: " + announcement +
		", won: " + won +
		", value: " + value +
		", createDate: " + createDate +
		", modifyDate: " + modifyDate
		+"]"
	}
}
