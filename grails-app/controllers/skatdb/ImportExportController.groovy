package skatdb

import java.util.Date;

import groovy.json.JsonBuilder;

class ImportExportController {

	def beforeInterceptor = [action:this.&auth]
	
    def index() {
		redirect(action: "importGames", params: params)
	}

	def auth() {
		if(!session.loggedIn) {
			redirect(controller:"Auth", action:"login")
			return false
		}
	}

	def importGames() {
		if(!params.group) {
			return
		}
		def groupId = params.group.id
		def importString = params.importTextArea
		if(importString == null || importString.length() <= 0) {
			flash.error = "Import Feld ist leer"
		} else {
			List<String> errorList = null
			if(params.importTextArea.contains("[")) {
				errorList = ImportUtils.doJSONImport(params.importTextArea)
			} else {
				errorList = ImportUtils.doTextImport(groupId, params.importTextArea, params.fakeDate)
			}
			if(errorList.size() == 0) {
				flash.message = "Import erfolgreich"
			} else {
				flash.error = "Import fehlgeschlagen. Die folgenden Einträge konnten nicht importiert werden."+
							  " Bitte beachten Sie, das die restlichen Spiele erfolgreich importiert wurden."
				flash.errorList = errorList
			}
		}
	}

	def exportJSON() {
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
						createDate: g.createDate.time,
						modifyDate: g.modifyDate.time
					)
		        }
		    }
		}
	}

}
