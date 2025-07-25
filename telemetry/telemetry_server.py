from flask import Flask, request, jsonify
import datetime

app = Flask(__name__)

@app.route('/log', methods=['POST'])
def receive_log():
    data = request.get_json()
    timestamp = datetime.datetime.utcnow().isoformat() + "Z"
    log_entry = {**data, "received_at": timestamp}

    with open("telemetry_received.jsonl", "a") as f:
        f.write(f"{log_entry}\n")
    return jsonify({"status": "received", "timestamp": timestamp}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
