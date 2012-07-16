package skatdb

class Game {

	SkatGroup group
	Player player

	int bid= 18

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
	 * game(1)
	 * schneider(2) | hand (2)
	 * schwarz(3) | hand schneider (3)
	 * schneider_announced(4),
	 * schwarz(5),
	 * schwarz_announced(6),
	 * ouvert(7)
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

    static constraints = {
		group()
		player()
		bid()
		jacks()
		hand()
		gameType(inList: [9, 10, 11, 12, 24, 23, 35, 46, 59])
		gameLevel(inList: [1, 2, 3, 4, 5, 6, 7])
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

	int calcValue() {
		int value = 0
		if(isNullGame()) {
			value = gameType
		} else {
			value = gameType * (jacks + gameLevel)
		}
		value *= announcement;
		if(!won) {
			value = value * -2;
		}
		return value;
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
