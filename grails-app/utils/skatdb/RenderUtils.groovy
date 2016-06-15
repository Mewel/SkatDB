package skatdb

import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public abstract class RenderUtils {

	public static Integer gamesPerRound(TournamentGroup group) {
		Tournament t = group.tournament;
		int gamesPerRound = t.gamesPerRound;
		if(group.players.size() == 3) {
			gamesPerRound = (gamesPerRound / 4) * 3;
		}
		return gamesPerRound
	}

	public static Map getGameStatistics(Player player, SkatGroup group, Date filterPeriodFrom, Date filterPeriodTo) {
		def query = Game.where {}
		if(player != null) {
			query = query.where {
				player == player
			}
		}
		if(group != null) {
			query = query.where {
				group == group
			}
		}
		if(filterPeriodFrom != null) {
			query = query.where {
				createDate >= filterPeriodFrom
			}
		}
		if(filterPeriodTo != null) {
			query = query.where {
				createDate <= filterPeriodTo
			}
		}
		[
			games: query.count(),
			suitGames: query.countByGameTypeBetweenAndBidNotEqual(9, 12, 0),
			grands: query.countByGameType(24),
			nullGames: query.countByGameTypeInList([23, 35, 46, 59]),
			gamesWon: query.countByWon(true),
			suitGamesWon: query.countByGameTypeBetweenAndWonAndBidNotEqual(9, 12, true, 0),
			grandsWon: query.countByGameTypeAndWon(24, true),
			nullGamesWon: query.countByGameTypeInListAndWon([23, 35, 46, 59], true),
			ramschGames: query.countByBid(0),
			ramschGamesWon: query.countByBidAndWon(0, true)
		]
	}

	public static ArrayList getPlayerInfo(List<Player> playerList, SkatGroup group, Date filterDateFrom, Date filterDateTo, boolean showZeroGames) {
		def playerInfoList = [];
		for (Player p : playerList) {
			List<Game> games = null
			int won = 0
			if (filterDateFrom == null && filterDateTo == null) {
				games = group == null ? Game.findAllByPlayer(p) : Game.findAllByPlayerAndGroup(p, group);
				won = group == null ? Game.countByPlayerAndWon(p, true) : Game.countByPlayerAndGroupAndWon(p, group, true)
			} else {
				games = group == null ? Game.findAllByPlayerAndCreateDateBetween(p, filterDateFrom, filterDateTo) :
						Game.findAllByPlayerAndGroupAndCreateDateBetween(p, group, filterDateFrom, filterDateTo)
				won = group == null ? Game.countByPlayerAndWonAndCreateDateBetween(p, true, filterDateFrom, filterDateTo) :
						Game.countByPlayerAndGroupAndWonAndCreateDateBetween(p, group, true, filterDateFrom, filterDateTo)
			}
			if (showZeroGames || games.size() > 0) {
				playerInfoList.push([
						player: p,
						count : games.size(),
						won   : won,
						points: games.size() > 0 ? games.sum { it.value } : 0
				])
			}
		}
		playerInfoList.sort {a, b -> -(a.points <=> b.points)}
		return playerInfoList
	}

	public static ArrayList getPlayerInfo(TournamentGroup group) {
		def playerInfoList = [];
		for (Player p : group.players) {
			int games = 0;
			int won = 0;
			int points = 0;
			for(Game g : group.games) {
				if(p.id == g.player.id) {
					games++
					won += g.won ? 1 : 0
					points += g.value
				}
			}
			playerInfoList.push([
				player: p,
				count : games,
				won   : won,
				points: points
			])
		}
		playerInfoList.sort {a, b -> -(a.points <=> b.points)}
		return playerInfoList
	}

}
