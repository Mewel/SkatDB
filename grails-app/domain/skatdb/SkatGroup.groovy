package skatdb

class SkatGroup {
	String name
	static hasMany = [games: Game]

	String toString () {
		"${name}"
	}

    static constraints = {
		name(blank: false)
    }
}
