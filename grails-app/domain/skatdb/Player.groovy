package skatdb

class Player {
	String name
	static hasMany = [games: Game]

	String toString () {
		"${name}"
	}

    static constraints = {
		name(blank: false)
    }

	@Override
	public boolean equals(Object o) {
		if(!(o instanceof Player))
			return false
		Player p = (Player)o;
		if(p.id != id) {
			return false
		}
		if(!p.name.equals(name)) {
			return false
		}
		return true
	}

}
