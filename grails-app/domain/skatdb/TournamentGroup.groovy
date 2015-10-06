package skatdb

class TournamentGroup {

	Tournament tournament
	TournamentRound round
	static hasMany = [games: Game, players: Player]

    static constraints = {
		tournament() 
    }

}
