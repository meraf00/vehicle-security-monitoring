import os
import requests
from getpass import getpass
import socketio
import random


STORAGE_LOCATION = "session"
API_URL = "http://localhost:3000/"

sio = socketio.Client()


class Location:

    @property
    def latitude(self):
        return random.randint(1, 100) + random.random()

    @property
    def longitude(self):
        return random.randint(1, 100) + random.random()


class Auth:
    def __init__(self):
        self.token = None
        self.session_filename = "session"
        self.load_session()

    @property
    def is_logged_in(self):
        return self.token is not None

    def load_session(self):
        try:
            with open(os.path.join(STORAGE_LOCATION, self.session_filename), "r") as f:
                self.token = f.read()
        except FileNotFoundError:
            self.token = None

    def login(self, email, password):
        response = requests.post(
            API_URL + "auth/login", json={"email": email, "password": password}
        )
        if response.status_code == 200:
            self.token = response.json()["token"]

            with open(os.path.join(STORAGE_LOCATION, self.session_filename), "w") as f:
                f.write(self.token)
            return True

    def logout(self):
        self.token = None
        os.remove(os.path.join(STORAGE_LOCATION, self.session_filename))


@sio.event
def connect():
    print("I'm connected!")


@sio.event
def connect_error(data):
    print("The connection failed!")


@sio.event
def disconnect():
    print("I'm disconnected!")


if __name__ == "__main__":

    os.makedirs(STORAGE_LOCATION, exist_ok=True)

    auth = Auth()

    print("Login to continue")
    while not auth.is_logged_in:
        email = input("Enter your email: ")
        password = getpass("Enter your password: ")

        if not auth.login(email, password):
            print("Invalid email or password. Please try again.")

        print()

    sio.connect(API_URL)

    location = Location()

    while True:
        try:

            sio.emit(
                "vehicle_status",
                {"latitude": location.latitude, "longitude": location.longitude},
            )
            sio.sleep(1)

        except KeyboardInterrupt:
            break

    sio.disconnect()
