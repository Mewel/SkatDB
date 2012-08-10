package skatdb

import groovy.json.JsonSlurper

class JSONController {

	def index() {
	}

	/**
	* Add or get players from the database. POST content should be an JSON array in
	* the form of: ["player1", "player2" ...]. If one of the players name is already
	* in the database this specific player is ignored and not added.
	*
	* @return json with status information
	*/
	def players() {
		if(request.method == 'GET') {
			List<Player> results = Player.list()
			render(contentType: "text/json") {
				for (p in results) {
					element p.name
				}
			}
		} else if(request.method == 'POST') {
			def postMsg = request.reader.text;
			if(!postMsg) {
				renderNoPostData()
				return
			}
			def players = new JsonSlurper().parseText( postMsg )
			int addedPlayers = 0
			for(def i = 0; i < players.size; i++) {
				Player p = Player.findByName(players[i]);
				if(!p) {
					p = Player.create()
					p.name = players[i]
					p.save()
					addedPlayers++
				}
			}
			render(contentType: "text/json") {
				status = "ok";
				added = addedPlayers;
			}
		} else {
			render(contentType: "text/json") {
				status = "invalid request method '" + request.method + "'";
			}
		}
	}

	/**
	* Add or get groups from the database. POST content should be an JSON array in
	* the form of: ["group1", "group2" ...]. If one of the group names is already
	* in the database this specific group is ignored and not added.
	*
	* @return json with status information
	*/
	def groups() {
		if(request.method == 'GET') {
			List<SkatGroup> results = SkatGroup.list()
			render(contentType: "text/json") {
				for (g in results) {
					element g.name
				}
			}
		} else if(request.method == 'POST') {
			def postMsg = request.reader.text;
			if(!postMsg) {
				renderNoPostData()
				return
			}
			def groups = new JsonSlurper().parseText( postMsg )
			int addedGroups = 0;
			for(def i = 0; i < groups.size; i++) {
				SkatGroup g = SkatGroup.findByName(groups[i]);
				if(!g) {
					g = SkatGroup.create()
					g.name = groups[i]
					g.save()
					addedGroups++
				}
			}
			render(contentType: "text/json") {
				status = "ok";
				added = addedGroups;
			}
		} else {
			render(contentType: "text/json") {
				status = "invalid request method '" + request.method + "'";
			}
		}	
	}

	def games() {
		if(request.method == 'GET') {
		List<Game> results = Game.all
			render(contentType: "text/json") {
				array {
					for (g in results) {
						game(
								group: g.group.name,
								player: g.player.name,
								bid: g.bid,
								jacks: g.jacks,
								gameType: g.gameType,
								hand: g.hand,
								gameLevel: g.gameLevel,
								announcement: g.announcement,
								won: g.won,
								value: g.value,
								createDate: g.createDate.time,
								modifyDate: g.modifyDate.time
								)
					}
				}
			}
		} else if(request.method == 'POST') {
			def postMsg = request.reader.text;
			if(!postMsg) {
				renderNoPostData()
				return
			}
			try {
				def errors = ImportUtils.doJSONImport(postMsg)
				if(errors) {
					render(contentType: "text/json") {
						status = "ok";
						msg = "Some hands couldn't be imported because they are invalid";
						handList = errors;
					}
					return
				}
			} catch(Exception exc) {
				render(contentType: "text/json") {
					status = "error";
					msg = "Invalid json data: '" + postMsg + "'";
					exc = exc;
				}
				return
			}
			render(contentType: "text/json") { status = "ok"; msg = "All hands successfully imported"}
		} else {
			render(contentType: "text/json") {
				status = "invalid request method '" + request.method + "'";
			}
		}
	}

	private void renderNoPostData() {
		render(contentType: "text/json") {
			status = "error";
			msg = "No POST data";
		}
	}
}
