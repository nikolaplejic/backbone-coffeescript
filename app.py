from bson import json_util, dbref
import pprint
import json
from flask import Flask, abort, g, request
from mongokit import Connection

# ---

MONGODB_HOST = 'localhost'
MONGODB_PORT = 27017

app = Flask(__name__)
app.debug = True
app.config.from_object(__name__)

mongo = Connection(app.config['MONGODB_HOST'],
                   app.config['MONGODB_PORT'])

# ---

@app.route('/', methods=['GET'])
def index():
  abort(403)

@app.route('/clients', methods=['GET', 'POST'])
def clients():
  if request.method == 'POST':
    data = json.loads(request.data)
    coll = mongo['tt'].clients
    oid = coll.insert(data)
    return json.dumps(data, default=json_util.default)
  elif request.method == 'GET':
    data = list(mongo['tt'].clients.find())
    return json.dumps(data, default=json_util.default)

@app.route('/projects', methods=['GET', 'POST'])
def projects():
  if request.method == 'POST':
    data = json.loads(request.data)
    data["client"] = dbref.DBRef("clients", data["client"])
    coll = mongo['tt'].projects
    oid = coll.insert(data)
    return json.dumps(data, default=json_util.default)
  elif request.method == 'GET':
    data = list(mongo['tt'].projects.find())
    return json.dumps(data, default=json_util.default)

if __name__ == '__main__':
  app.run()
