package skatdb

import groovy.json.JsonSlurper;

import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.codehaus.groovy.grails.orm.hibernate.HibernateSession;
import org.hibernate.HibernateException;
import org.hibernate.Transaction;

abstract class ImportUtils {

	private static int getGameTypeOfString(String line) {
		if(line.contains(" schellen")) {
			return 9;
		} else if(line.contains(" rot")) {
			return 10;
		} else if(line.contains(" grün")) {
			return 11;
		}else if(line.contains(" eicheln")) {
			return 12;
		} else if(line.contains(" grand")) {
			return 24;
		} else if(line.contains(" null")) {
			return 23;
		}
		throw new IllegalArgumentException(line)
	}

	private static int getGameLevel(boolean hand, boolean schneider, boolean schwarz, boolean ouvert, boolean angesagt) {
		if(hand) {
			if(ouvert) {
				return 7
			}
			if(schwarz && angesagt) {
				return 6
			}
			if(schwarz) {
				return 5
			}
			if(schneider && angesagt) {
				return 4
			}
			if(schneider) {
				return 3
			}
			return 2
		} else {
			if(schwarz) {
				return 3
			}
			if(schneider) {
				return 2
			}
			return 1
		}
	}

	public static ArrayList<String> doJSONImport(String json, closure) {
		def errorList = []
		JsonSlurper slurper = new JsonSlurper()
		def result = slurper.parseText(json)
		// TODO: don't use Game class here, use more general one
		Game.withNewSession { session ->
			Transaction tr = session.beginTransaction()
			try {
				closure(result)
				tr.commit()
			} catch(Throwable t) {
				tr.rollback()
				throw new HibernateException("Exception while transaction. The transaction is rolled back.", t)
			}
		};
		return errorList
	}

	public static ArrayList<String> doJSONImport(String json) {
		return doJSONImport(json, { result ->
			for(Object o in result) {
				try {
					if(o.group != null && o.player != null) {
						Game game = handleGame(o, null)
						game.save()
					} else if(o.gamesPerRound != null) {
						handleTournament(o)
					}
				} catch(Exception exc) {
					Logger.getLogger(this).error("while parsing json object: " + o, exc)
					errorList.push(o)
				}
			}
		})
	}

	public static Game handleGame(json, group) {
		Game game = new Game()
		game.group = group != null ? group : findOrCreateGroup(json.group)
		game.player = findOrCreatePlayer(json.player)
		game.bid = json.bid  != null ? json.bid : 18
		game.gameType = json.gameType != null ? json.gameType : 9
		game.hand = json.hand != null ? json.hand : false
		game.gameLevel = json.gameLevel != null ? json.gameLevel : 1
		// ramsch uses jacks as value
		game.jacks =  json.bid == null || json.bid != 0 ? (json.jacks != null ? json.jacks : 1) : (json.value  / json.gameLevel)
		game.announcement = json.announcement != null ? json.announcement : 1
		game.won = json.won != null ? json.won : true
		game.createDate = json.createDate != null ? new Date(json.createDate) : new Date()
		game.modifyDate = json.modifyDate != null ? new Date(json.modifyDate) : new Date()
		return game
	}

	public static void handleTournament(json) {
		Tournament t = Tournament.create();
		t.name = json.name;
		t.status = Integer.valueOf(json.status);
		t.gamesPerRound = Integer.valueOf(json.gamesPerRound);
		t.rounds = new ArrayList<TournamentRound>();
		t.players = new HashSet<Player>()

		// rounds
		if(json.rounds != null) {
			for(Object round in json.rounds) {
				TournamentRound r = TournamentRound.create();
				r.tournament = t
				r.groups = new ArrayList<TournamentGroup>()
				// groups
				if(round.groups != null) {
					for(Object group in round.groups) {
						TournamentGroup g = TournamentGroup.create();
						g.tournament = t;
						g.round = r;
						g.players = new HashSet<Player>()
						g.games = new HashSet<Game>()
						// players
						if(group.players != null) {
							for(String player in group.players) {
								Player p = findOrCreatePlayer(player);
								g.players.add(p)
								t.players.add(p)
							}
						}
						// games
						if(group.games != null) {
							for(Object jsonGame in group.games) {
								Game game = handleGame(jsonGame, t)
								game.importMode = true
								g.games.add(game)
							}
						}
						r.groups.add(g);
					}
				}
				t.rounds.add(Integer.valueOf(round.index), r)
			}
		}
		t.save()
	}

	public static SkatGroup findOrCreateGroup(String name) {
		SkatGroup group = SkatGroup.findByName(name)
		if(group == null) {
			group = new SkatGroup()
			group.name = name
			group.save()
		}
		return group
	}

	public static Player findOrCreatePlayer(String name) {
		Player player = Player.findByName(name)
		if(player == null) {
			player = new Player()
			player.name = name
			player.save()
		}
		return player
	}
}
