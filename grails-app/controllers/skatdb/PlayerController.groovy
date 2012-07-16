package skatdb

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

}
