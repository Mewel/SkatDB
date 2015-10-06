package skatdb

class Tournament extends SkatGroup {

	// 0 = created, 1 = running, 2 = finished
	Integer status = 0

	Integer gamesPerRound

	List<TournamentRound> rounds

	static hasMany = [players: Player, rounds: TournamentRound]

    static constraints = {
		gamesPerRound(inList: [12, 24, 36, 48, 60])
		status(inList: [0, 1, 2])
    }

	def addGame(Game game) {
		if(status == 2) {
			return
		}
		TournamentRound round = rounds.last();
		for(TournamentGroup group : round.groups) {
			if(group.players.contains(game.player)) {
				group.games.add(game)
				group.save()
				break;
			}
		}
	}

	def TournamentGroup getGroupByGame(Game game) {
		for(TournamentRound round : rounds) {
			for(TournamentGroup group : round.groups) {
				if(group.games.contains(game)) {
					return group;
				}
			}
		}
		return null;
	}

}
