from flask import Flask, request, redirect, make_response
from werkzeug.security import generate_password_hash, check_password_hash
import sqlite3
import urllib
import quoter_templates as templates

# Run using `poetry install && poetry run flask run --reload`
app = Flask(__name__)
app.static_folder = '.'

# Open the database. Have queries return dicts instead of tuples.
# The use of `check_same_thread` can cause unexpected results in rare cases. We'll
# get rid of this when we learn about SQLAlchemy.
db = sqlite3.connect("db.sqlite3", check_same_thread=False)
db.row_factory = sqlite3.Row

# Log all requests for analytics purposes
log_file = open('access.log', 'a', buffering=1)
@app.before_request
def log_request():
    log_file.write(f"{request.method} {request.path} {dict(request.form) if request.form else ''}\n")


# Set user_id on request if user is logged in, or else set it to None.
@app.before_request
def check_authentication():
    if 'user_id' in request.cookies:
        request.user_id = int(request.cookies['user_id'])
    else:
        request.user_id = None


# The main page
@app.route("/")
def index():
    quotes = db.execute("select id, text, attribution from quotes order by id").fetchall()
    return templates.main_page(quotes, request.user_id, request.args.get('error'))


# The quote comments page
@app.route("/quotes/<int:quote_id>")
def get_comments_page(quote_id):
    quote = db.execute("select id, text, attribution from quotes where id=?", (quote_id,)).fetchone()
    comments = db.execute("select text, datetime(time,'localtime') as time, name as user_name from comments c left join users u on u.id=c.user_id where quote_id=? order by c.id", (quote_id,)).fetchall()
    return templates.comments_page(quote, comments, request.user_id)


# Post a new quote
@app.route("/quotes", methods=["POST"])
def post_quote():
    # Basic input validation
    text = request.form.get('text', '').strip()
    attribution = request.form.get('attribution', '').strip()
    
    if not text or not attribution:
        return redirect("/?error=" + urllib.parse.quote("Both quote text and attribution are required!"))
    
    if len(text) > 1000 or len(attribution) > 200:
        return redirect("/?error=" + urllib.parse.quote("Quote or attribution is too long!"))
    
    with db:
        db.execute("insert into quotes(text,attribution) values(?, ?)", (text, attribution))
    return redirect("/#bottom")


# Post a new comment
@app.route("/quotes/<int:quote_id>/comments", methods=["POST"])
def post_comment(quote_id):
    if not request.user_id:
        return redirect("/")  # Redirect if not logged in
    
    # Basic input validation
    text = request.form.get('text', '').strip()
    
    if not text:
        return redirect(f"/quotes/{quote_id}")
    
    if len(text) > 1000:
        return redirect(f"/quotes/{quote_id}")
    
    with db:
        db.execute("insert into comments(text,quote_id,user_id) values(?, ?, ?)", (text, quote_id, request.user_id))
    return redirect(f"/quotes/{quote_id}#bottom")


# Sign in user
@app.route("/signin", methods=["POST"])
def signin():
    username = request.form.get("username", "").lower().strip()
    password = request.form.get("password", "")
    
    # Basic input validation
    if not username or not password:
        return redirect('/?error='+urllib.parse.quote("Username and password are required!"))
    
    if len(username) > 50 or len(password) > 200:
        return redirect('/?error='+urllib.parse.quote("Username or password is too long!"))
    
    # Prevent simple username injection attempts
    if any(char in username for char in ['<', '>', '"', "'"]):
        return redirect('/?error='+urllib.parse.quote("Invalid username format!"))

    user = db.execute("select id, password from users where name=?", (username,)).fetchone()
    if user: # user exists
        if not check_password_hash(user['password'], password):
            # wrong! redirect to main page with an error message
            return redirect('/?error='+urllib.parse.quote("Invalid password!"))
        user_id = user['id']
    else: # new sign up
        with db:
            hashed_pw = generate_password_hash(password)
            cursor = db.execute("insert into users(name,password) values(?, ?)", (username, hashed_pw))
            user_id = cursor.lastrowid

    response = make_response(redirect('/'))
    # Set secure cookie flags to prevent session hijacking
    response.set_cookie('user_id', str(user_id), httponly=True, secure=False, samesite='Lax')
    return response


# Sign out user
@app.route("/signout", methods=["GET"])
def signout():
    response = make_response(redirect('/'))
    # Properly delete the cookie with same flags as when it was set
    response.delete_cookie('user_id', httponly=True, samesite='Lax')
    return response
