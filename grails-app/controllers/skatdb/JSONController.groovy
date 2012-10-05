package skatdb

import groovy.json.JsonSlurper
import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ADMIN'])
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
		response.setHeader("Access-Control-Allow-Origin", "*")
		if(request.method == 'GET') {
			List<Player> results = Player.list()
			render(contentType: "text/json") {
				if(!results.empty) {
					for (p in results) {
						element p.name
					}
				} else {
					[]
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
			render(contentType: "text/json") { status = 400; msg = 'Invalid Request method ' + request.method}
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
		response.setHeader("Access-Control-Allow-Origin", "*")
		if(request.method == 'GET') {
			List<SkatGroup> results = SkatGroup.list()
			render(contentType: "text/json") {
				if(!results.empty) {
					for (g in results) {
						element g.name
					}
				} else {
					[]
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
			render(contentType: "text/json") { status = 400; msg = 'Invalid Request method ' + request.method}
		}
	}

	def games() {
		response.setHeader("Access-Control-Allow-Origin", "*")
		if(request.method == 'GET') {
			List<Game> results = Game.all
			render(contentType: "text/json") {
				if(!results.empty) {
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
				} else {[]}
			}
		} else if(request.method == 'POST') {
			def postMsg = params.get("games")
			if(!postMsg) {
				render(contentType: "text/json") { status = 400; msg = 'No "games" parameter defined'}
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
				log.error("while import", exc)
				render(contentType: "text/json") { status = 400; msg = "Invalid json data: '" + postMsg + "'"}
				return
			}
			render(contentType: "text/json") { status = 200; msg = "All hands successfully imported"}
		} else {
			render(contentType: "text/json") { status = 400; msg = 'Invalid Request method ' + request.method}
		}
	}

	private void renderNoPostData() {
		render(contentType: "text/json") { status = 400; msg = 'No POST data'}
	}
}
