from flask import Flask, render_template, request, redirect, session
import mysql.connector

app = Flask(__name__)
app.secret_key = "sportsclub_secret_2026"

db = mysql.connector.connect(
    host="127.0.0.1",
    user="root",
    password="91449114",  
    database="sports_club_db"
)
cursor = db.cursor()

# ── Club config ────────────────────────────────────────────
CLUB_CONFIG = {
    "MI":     {"sport": "cricket",  "name": "Mumbai Indians"},
    "CSK":    {"sport": "cricket",  "name": "Chennai Super Kings"},
    "RR":     {"sport": "cricket",  "name": "Rajasthan Royals" },
    "FCB":    {"sport": "football", "name": "FC Barcelona"},
    "RMA":    {"sport": "football", "name": "Real Madrid"},
    "PSG":    {"sport": "football", "name": "Paris Saint-Germain"},
    "UP":     {"sport": "kabaddi",  "name": "UP Yoddhas"},
    "Jaipur": {"sport": "kabaddi",  "name": "Jaipur Pink Panthers"},
    "Patna":  {"sport": "kabaddi",  "name": "Patna Pirates"},
}

PLAYER_TYPES = {
    "cricket":  ["Batsman", "Bowler", "Allrounder", "Wicketkeeper"],
    "football": ["Goalkeeper", "Defender", "Midfielder", "Forward"],
    "kabaddi":  ["Raider", "Defender", "Allrounder"],
}

# Coaches per club (you can update these names as needed)
COACHES = {
    "MI":     ["Mahela Jayawardene", "Shane Bond", "Robin Singh", "Jonty Rhodes"],
    "CSK":    ["Stephen Fleming", "Mike Hussey", "Lakshmipathy Balaji", "Eric Simons"],
    "RR":     ["Kumar Sangakkara", "Paddy Upton", "Zubin Bharucha", "Sairaj Bahutule"],
    "FCB":    ["Hansi Flick", "Juan Carlos Unzue", "Pau Danus", "Albert Puig"],
    "RMA":    ["Carlo Ancelotti", "Paul Clement", "Francisco Seco", "Luis Llopis"],
    "PSG":    ["Luis Enrique", "Thierry Henry", "Jessy Moulin", "Ruben Cousillas"],
    "UP":     ["Raju Harishchandran", "Krishan Hooda", "Rishank Devadiga", "Surender Nada"],
    "Jaipur": ["Baharke Naik", "Sanjeev Kumar", "Jasvir Singh", "Balwan Singh"],
    "Patna":  ["Ram Mehar Singh", "Ranjit Naik", "Vinod Kumar", "Dinesh Kumar"],
}

def tbl(club):
    return f"players_{club.lower()}"


# ── LOGIN ──────────────────────────────────────────────────
@app.route('/', methods=['GET', 'POST'])
def login():
    error = None

    if request.method == 'POST':

        username = request.form['username']
        password = request.form['password']

        # Admin Login
        if username == "admin" and password == "admin123":
            session['role'] = 'admin'
            return redirect('/dashboard')

        # Player Login
        cursor.execute(
            "SELECT * FROM player_login WHERE username=%s AND password=%s",
            (username, password)
        )

        player = cursor.fetchone()

        if player:
            session['role'] = 'player'
            session['player_id'] = player[3]
            session['club'] = player[4]

            return redirect('/myprofile')

        # Invalid Login
        error = "Invalid username or password."

    return render_template('login.html', error=error)

## ── MYPROFILE ─────────────────────────────────────────────
@app.route('/myprofile')
def myprofile():

    pid = session['player_id']
    club = session['club']

    cursor.execute(
        f"SELECT * FROM {tbl(club)} WHERE id=%s",
        (pid,)
    )

    data = cursor.fetchone()

    return render_template('myprofile.html', p=data)
	

# ── DASHBOARD ─────────────────────────────────────────────
@app.route('/dashboard')
def dashboard():
    return render_template('dashboard.html')


# ── PLAYERS ------------------------------------------------------- ───
@app.route('/players/<club>')
def players(club):
    cfg    = CLUB_CONFIG.get(club, {})
    sport  = cfg.get('sport', 'cricket')
    ptypes = PLAYER_TYPES.get(sport, [])
    coaches = COACHES.get(club, [])
    cursor.execute(f"SELECT * FROM {tbl(club)}")
    data = cursor.fetchall()
    return render_template('players.html', players=data, club=club, cfg=cfg, ptypes=ptypes, coaches=coaches)


# ── ADD PLAYER ────────────────────────────────────────────
@app.route('/add_player', methods=['POST'])
def add_player():
    club   = request.form['club']
    name   = request.form['name']
    age    = request.form['age']
    ptype  = request.form['type']
    coach  = request.form['coach']
    expiry = request.form['expiry']
    fees   = request.form['fees']
    cursor.execute(
        f"INSERT INTO {tbl(club)} (name, age, type, coach, expiry, fees) VALUES (%s,%s,%s,%s,%s,%s)",
        (name, age, ptype, coach, expiry, fees)
    )
    db.commit()
    return redirect(f'/players/{club}')


# ── DELETE ────────────────────────────────────────────────
@app.route('/delete/<club>/<int:pid>')
def delete(club, pid):
    cursor.execute(f"DELETE FROM {tbl(club)} WHERE id=%s", (pid,))
    db.commit()
    return redirect(f'/players/{club}')


# ── UPDATE ────────────────────────────────────────────────
@app.route('/update/<club>/<int:pid>', methods=['GET', 'POST'])
def update(club, pid):
    cfg    = CLUB_CONFIG.get(club, {})
    sport  = cfg.get('sport', 'cricket')
    ptypes = PLAYER_TYPES.get(sport, [])
    coaches = COACHES.get(club, [])

    if request.method == 'POST':
        cursor.execute(
            f"UPDATE {tbl(club)} SET name=%s, age=%s, type=%s, coach=%s, expiry=%s, fees=%s WHERE id=%s",
            (request.form['name'], request.form['age'], request.form['type'],
             request.form['coach'], request.form['expiry'], request.form['fees'], pid)
        )
        db.commit()
        return redirect(f'/players/{club}')

    cursor.execute(f"SELECT * FROM {tbl(club)} WHERE id=%s", (pid,))
    player = cursor.fetchone()
    return render_template('update.html', p=player, club=club, cfg=cfg, ptypes=ptypes, coaches=coaches)


if __name__ == '__main__':
    app.run(debug=True)
