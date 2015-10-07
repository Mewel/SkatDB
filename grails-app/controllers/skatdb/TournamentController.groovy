package skatdb

import java.awt.event.ItemEvent;

class TournamentController {

	def beforeInterceptor = [action:this.&auth]

	def scaffold=true
	
    def index() {
		redirect(action: "list")
	}

	def auth() {
		if(!session.loggedIn) {
			redirect(controller:"Auth", action:"login")
			return false
		}
	}

	def show() {
		def tournament = Tournament.get(params.id)
		if(tournament == null) {
			return response.sendError(404, "Tournament with id " + params.id + " not found.")
		}
		def results = RenderUtils.getPlayerInfo(new ArrayList(tournament.players), tournament, null, null, true)
		[
			tournamentInstance: tournament,
			results: results
		]
	}

	def setStatus(int status) {
		Tournament tournament = Tournament.findById(params.id)
		if(tournament == null) {
			return response.sendError(404, "Tournament with id " + params.id + " not found.")
		}
		tournament.status = status
		tournament.save()
		redirect(action: "show", id: params.id)
	}

	def startTournament() {
		setStatus(1)
	}
	
	def finishTournament() {
		setStatus(2)
	}

	def newRound() {
		Tournament tournament = Tournament.findById(params.id)
		if(tournament == null) {
			return response.sendError(404, "Tournament with id " + params.id + " not found.")
		}
		// create groups
		int ps = tournament.players.size()
		if(ps < 3) {
			flash.error = "More players required to start a round."
			return redirect(action: "show", id: params.id)
		}
		if(ps == 5) {
			flash.error = "Tournament with five players is not supported yet. But its open source you know :)."
			return redirect(action: "show", id: params.id)
		}

		TournamentRound round = TournamentRound.create();
		round.groups = new ArrayList<TournamentGroup>()
		round.tournament = tournament
		List<Player> players = new ArrayList<>(tournament.players)

		int modulo = ps % 4
		int threePlayerGroups = modulo == 0 ? 0 : 4 - modulo;
		int fourPlayerGroups = (ps - (threePlayerGroups * 3)) / 4;

		createGroups(round, players, threePlayerGroups, 3);
		createGroups(round, players, fourPlayerGroups, 4);

		if(!players.isEmpty()) {
			flash.error = "Argh. Something got wrong while calculated player group assignment. There are some players not assigned."
			return redirect(action: "show", id: params.id)
		}
		tournament.rounds.add(round)
		tournament.save()
		redirect(action: "show", id: params.id)
	}

	def deleteRound() {
		TournamentRound round = TournamentRound.findById(params.id)
		if(round == null) {
			return response.sendError(404, "TournamentRound with id " + params.id + " not found.")
		}
		deleteTournamentRound(round)
		redirect(action: "show", id: round.tournament.id)
	}

	/**
	 * Deletes a whole round including all groups and all games played.
	 * 
	 * @param round to delete
	 */
	private void deleteTournamentRound(TournamentRound round) {
		for(TournamentGroup group : round.groups) {
			for(Game game : group.games) {
				game.delete()
			}
			group.delete()
		}
		round.delete()
	}
	
	/**
	 * Create groups and add them to the round.
	 * 
	 * @param round where to add the groups
	 * @param players list of all available players which should added to the groups
	 * @param amount amount of groups which should be added
	 * @param numPlayers number of players per group
	 */
	private void createGroups(TournamentRound round, List<Player> players, int amount, int numPlayers) {
		for(int g = 0; g < amount; g++) {
			TournamentGroup group = createGroup(players, numPlayers)
			group.tournament = round.tournament
			group.round = round
			round.groups.add(group)
		}
	}

	/**
	 * Creates a new group with random players of players list.
	 * 
	 * @param players list of all available players
	 * @param numPlayers amount of players which are randomly added
	 * @return
	 */
	private TournamentGroup createGroup(List<Player> players, int numPlayers) {
		Random rand = new Random();
		TournamentGroup group = TournamentGroup.create();
		group.players = new ArrayList<Player>()
		for(int p = 0; p < numPlayers; p++) {
			int i = rand.nextInt(players.size());
			group.players.add(players.get(i))
			players.remove(i);
		}
		return group
	}
}
