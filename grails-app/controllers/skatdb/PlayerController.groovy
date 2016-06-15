package skatdb

import org.apache.log4j.Logger;

class PlayerController {

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
		def player = Player.get(params.id)
		if(player == null) {
			return response.sendError(404, "Player with id " + params.id + " not found.")
		}
		
		// misc stuff
		def c = Game.createCriteria()
		List<Game> games = c {
			eq("player", player)
			order("modifyDate", "asc")
		}
		int won = 0,lost = 0,longestWon = 0, longestLost = 0
		Game bestGame = null, worstGame = null
		for(Game g : games) {
			if(bestGame == null && worstGame == null) {
				bestGame = worstGame = g
			}
			if(g.won) {
				won++
				lost = 0
			} else {
				lost++
				won = 0
			}
			if(won > longestWon) {
				longestWon = won
			}
			if(lost > longestLost) {
				longestLost = lost
			}
			if(bestGame.value < g.value) {
				bestGame = g
			}
			if(worstGame.value > g.value) {
				worstGame = g
			}
		}

		// tournament stuff
		int tournamentsPlayed = 0
		List<String> firstPlaces = []
		List<String> secondPlaces = []
		List<String> thirdPlaces = []
		
		List<Tournament> tournaments = Tournament.findAllByStatus(2).findAll {
			if(it.players.contains(player)) {
				tournamentsPlayed++
				Set<Player> ranks = it.getRanks()
				if(player.equals(ranks.toArray()[0])) {
					firstPlaces.add(it.id)
				}
				if(player.equals(ranks.toArray()[1])) {
					secondPlaces.add(it.id)
				}
				if(player.equals(ranks.toArray()[2])) {
					thirdPlaces.add(it.id)
				}
			}
		}
		[
			playerInstance: player,
			gameStatistics: RenderUtils.getGameStatistics(player, null, null, null),
			wonSeries: longestWon,
			lostSeries: longestLost,
			bestGame: bestGame,
			worstGame: worstGame,

			tournamentsPlayed: tournamentsPlayed,
			firstPlaces: firstPlaces,
			secondPlaces: secondPlaces,
			thirdPlaces: thirdPlaces
		]
	}

}
