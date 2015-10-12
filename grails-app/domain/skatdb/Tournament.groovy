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

	def Set<Player> getRanks() {
		List<Game> games = Game.findAllByGroup(this)
		Map<Player, Integer> m = new HashMap<>();
		for(Game g : games) {
			Integer v = m.get(g.player)
			m.put(g.player, v == null ? g.value : v + g.value)
		}
		m = sortByValue(m)
		return m.keySet()
	}

	/**
	 * @see http://stackoverflow.com/questions/109383/how-to-sort-a-mapkey-value-on-the-values-in-java
	 */ 
	public static <Player, Integer extends Comparable<? super Integer>> Map<Player, Integer> sortByValue( Map<Player, Integer> map ) {
		List<Map.Entry<Player, Integer>> list = new LinkedList<>( map.entrySet() );
		Collections.sort( list, new Comparator<Map.Entry<Player, Integer>>() {
			@Override
			public int compare( Map.Entry<Player, Integer> o1, Map.Entry<Player, Integer> o2 ) {
				return -(o1.getValue()).compareTo( o2.getValue() );
			}
		});
		Map<Player, Integer> result = new LinkedHashMap<>();
		for (Map.Entry<Player, Integer> entry : list) {
			result.put( entry.getKey(), entry.getValue() );
		}
		return result;
	}

}
