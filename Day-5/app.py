from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, Chandrasekhar! Your Flask app is running on AWS EC2 we crated from Terraform  🚀"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
