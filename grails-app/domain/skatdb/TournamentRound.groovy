package skatdb

class TournamentRound {

	Tournament tournament
	List<TournamentGroup> groups

	static hasMany = [groups: TournamentGroup]

    static constraints = {
		tournament() 
    }

}
