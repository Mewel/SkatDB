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

	public static ArrayList<String> doJSONImport(String json) {
		def errorList = []
		JsonSlurper slurper = new JsonSlurper()
		def result = slurper.parseText(json)
		final def closure = {
			for(Object jsonGame in result) {
				try {
					Game game = new Game()
					game.group = findOrCreateGroup(jsonGame.group)
					game.player = findOrCreatePlayer(jsonGame.player)
					game.bid = jsonGame.bid  != null ? jsonGame.bid : 18
					game.gameType = jsonGame.gameType != null ? jsonGame.gameType : 9
					game.hand = jsonGame.hand != null ? jsonGame.hand : false
					game.gameLevel = jsonGame.gameLevel != null ? jsonGame.gameLevel : 1
					// ramsch uses jacks as value
					game.jacks =  jsonGame.bid == null || jsonGame.bid != 0 ? (jsonGame.jacks != null ? jsonGame.jacks : 1) : (jsonGame.value  / jsonGame.gameLevel)
					game.announcement = jsonGame.announcement != null ? jsonGame.announcement : 1
					game.won = jsonGame.won != null ? jsonGame.won : true
					game.createDate = jsonGame.createDate != null ? new Date(jsonGame.createDate) : new Date()
					game.modifyDate = jsonGame.modifyDate != null ? new Date(jsonGame.modifyDate) : new Date()
					game.save()
				} catch(Exception exc) {
					Logger.getLogger(this).error("while parsing json object: " + jsonGame, exc)
					errorList.push(jsonGame)
				}
			}
		}
		Game.withNewSession { session ->
			Transaction tr = session.beginTransaction()
			try {
				closure()
				tr.commit()
			} catch(Throwable t) {
				tr.rollback()
				throw new HibernateException("Exception while transaction. The transaction is rolled back.", t)
			}
		};
		return errorList
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
