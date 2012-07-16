package skatdb

class AuthController {

    def index() {
        redirect(action: "login", params: params)
    }

	def login = {
		if("mypassword" == grailsApplication.config.skatdb.password) {
			flash.message = "Please change the default password 'mypassword' in Config.groovy"
		}
	}

	def authenticate = {
		if(params.password.equals(grailsApplication.config.skatdb.password)) {
			session.loggedIn = true
			flash.message = "Eingeloggt Junge"
			redirect(uri: "/")
		} else {
			flash.message = "Falsches Passwort."
			redirect(action:"login")
		}
	}

	def logout = {
		flash.message = "Tschö"
		session.loggedIn = false
		redirect(action:"login")
	}
}
