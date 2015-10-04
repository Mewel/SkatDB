package skatdb

import java.util.Date;

import groovy.json.JsonBuilder;

class ImportExportController {

	def beforeInterceptor = [action:this.&auth]

	def index() {
	}

	def auth() {
		if(!session.loggedIn) {
			redirect(controller:"Auth", action:"login")
			return false
		}
	}

	def importGames() {
		String importString = params.importTextArea
		if(importString == null || importString.length() <= 0) {
			flash.error = "Import Feld ist leer"
			return;
		}
		try {
			if(!importString.startsWith("[")) {
				importString = readFromURL(importString);
			}
			List<String> errorList = ImportUtils.doJSONImport(importString)
			if(errorList.size() == 0) {
				flash.message = "Import erfolgreich"
			} else {
				flash.error = "Import fehlgeschlagen. Die folgenden Einträge konnten nicht importiert werden."+
						" Bitte beachten Sie, das die restlichen Spiele erfolgreich importiert wurden."
				flash.errorList = errorList
			}
		} catch(Exception exc) {
			log.error("Unable to import games", exc)
			flash.error = "Import fehlgeschlagen: " + exc.getLocalizedMessage()
		}
		redirect(controller:"ImportExport")
	}

	private String readFromURL(String url) {
		URL oracle = new URL(url);
		URLConnection yc = oracle.openConnection();
		BufferedReader br = new BufferedReader(new InputStreamReader(yc.getInputStream()));
		StringBuffer b = new StringBuffer();
		String inputLine;
		while ((inputLine = br.readLine()) != null) {
			b.append(inputLine);
		}
		br.close();
		return b.toString()
	}
	
}
