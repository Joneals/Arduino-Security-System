from flask import Flask, render_template, request

app = Flask(__name__)
vars = {}
@app.route('/put')
def setValue():
	if "key" in request.args and "value" in request.args:
		key = request.args.get('key')
		value = request.args.get('value')
		vars[key] = value
		print("Stored pair " + key + " : " + value)
		return "0"
		
	return "-1"
	
@app.route('/get')
def getValue():
	if "key" in request.args:
		return vars.get(request.args.get("key"), "-1")

if __name__=='__main__':
    app.run(debug=True, port=3134)