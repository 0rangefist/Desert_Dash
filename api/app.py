""" Game Server API """

from flask import Flask, jsonify
from datetime import datetime, timedelta
from itertools import product
import json
import random
import threading

app = Flask(__name__)
daily_challenge = {}  # global var to hold daily challenge in memory
lock = threading.Lock()  # lock to protect the global var from multiple writes

# variables for building daily challenge tasks
collect_objects = ["coins"]
use_objects = ["hover", "shields"]
driveon_objects = ["roofs"]

# task builder variables
NUM_TASKS = random.randrange(3, 5)  # num of tasks per challenge
MIN_GOAL = 5  # min number for a task goal
MAX_GOAL = 10  # max number for a a task goal


def generate_daily_challenge():
    """
    Generates and returns a new daily challenge by building a task
    list, etc and saves the data to a json file for future use if needed
    """
    expiration_time = datetime.utcnow() + timedelta(days=1)
    challenge = {
        "tasks": build_tasks(NUM_TASKS, MIN_GOAL, MAX_GOAL),
        "expiration_time": expiration_time.isoformat(),
        "server_fetch_time": ""
    }
    with open("daily_challenge.json", "w") as challenge_file:
        json.dump(challenge, challenge_file)
    return challenge


def build_tasks(num_tasks, min_goal, max_goal):
    collect_combo = list(product(["collect"], collect_objects))
    use_combo = list(product(["use"], use_objects))
    driveon_combo = list(product(["drive-on"], driveon_objects))
    all_tasks = collect_combo + use_combo \
        + driveon_combo
    random.shuffle(all_tasks)  # Shuffle the list to make it random
    tasks = []
    for _ in range(num_tasks):
        # stop the loop if all_tasks is exhausted
        if not all_tasks:
            break
        # grab the first combo from all_tasks list
        task_type, object = all_tasks.pop()
        # Random goal between min and max.
        goal = random.randint(min_goal, max_goal)
        if task_type == "collect" and object == "coins":
            # coins are special and have a much higher goal value
            multiplier = 50
            # Round the random value to the nearest multiple of the multiplier
            goal = random.randrange(min_goal * multiplier,
                                    max_goal * multiplier,
                                    multiplier)
        # Construct the description of the task
        description = task_type.capitalize() + f" {goal} {object}"
        # Add the challenge to the list.
        tasks.append({
            "type": task_type,
            "object": object,
            "goal": goal,
            "description": description
        })

    return tasks


@app.route("/api/daily-challenge", methods=["GET"])
def get_daily_challenge():
    """
    Primary endpoint to get the current daily challenge
    """
    global daily_challenge
    current_time = datetime.utcnow()
    expiration_time = ""
    # lock access to prevent concurrent writes to daily_challenge
    # ensuring data consistency accross multiple api calls
    with lock:
        if daily_challenge:  # if daily_challenge is in memory, try to use that
            expiration_time = datetime.fromisoformat(
                daily_challenge["expiration_time"])
            if current_time > expiration_time:
                daily_challenge = generate_daily_challenge()
        else:  # if not in memory, load from file
            try:
                with open("daily_challenge.json", "r") as challenge_file:
                    daily_challenge = json.load(challenge_file)
                    # Check if challenge is still valid based on expiration.
                    expiration_time = datetime.fromisoformat(
                        daily_challenge["expiration_time"])
                    if current_time > expiration_time:
                        daily_challenge = generate_daily_challenge()
            except FileNotFoundError:  # if no file, generate new challenge
                daily_challenge = generate_daily_challenge()
        daily_challenge["server_fetch_time"] = datetime.utcnow().isoformat()
    return jsonify(daily_challenge), 200
