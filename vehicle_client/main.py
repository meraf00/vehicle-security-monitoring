import os
import requests
from getpass import getpass
import socketio
import random
import threading


STORAGE_LOCATION = "session"
API_URL = "https://astu-biometric-vehicle-security.onrender.com/"

sio = socketio.Client()


class Location:
    # Location logic goes here

    @property
    def latitude(self):
        return random.randint(1, 100) + random.random()

    @property
    def longitude(self):
        return random.randint(1, 100) + random.random()


class VehicleState:
    def __init__(self):
        self.locked = True

    def unlock(self):
        # vehicle unlocking logic goes here
        self.locked = False

    def lock(self):
        # vehicle locking logic goes here
        self.locked = True


class Auth:
    def __init__(self):
        self.token = None
        self.plate = None
        self.email = None
        self.session_filename = "session"
        self.load_session()

    @property
    def is_logged_in(self):
        return self.token is not None

    def load_session(self):
        try:
            with open(os.path.join(STORAGE_LOCATION, self.session_filename), "r") as f:
                self.token, self.plate, self.email = f.read().splitlines()

        except FileNotFoundError:
            self.token = None

    def get_vehicle(self):
        response = requests.get(
            API_URL + f"vehicles/{self.plate}",
            headers={"Authorization": f"Bearer {self.token}"},
        )
        if response.status_code == 200:
            return True

        return False

    def add_vehicle(self):
        response = requests.post(
            API_URL + "vehicles/",
            json={"plate": self.plate},
            headers={"Authorization": f"Bearer {self.token}"},
        )
        if response.status_code == 200:
            return True

    def login(self, email, password, plate):
        response = requests.post(
            API_URL + "auth/login", json={"email": email, "password": password}
        )
        if response.status_code == 200:
            self.token = response.json()["token"]
            self.plate = plate
            self.email = email

            if not self.get_vehicle():
                if not self.add_vehicle():
                    self.token = None
                    self.plate = None
                    self.email = email
                    return False

            with open(os.path.join(STORAGE_LOCATION, self.session_filename), "w") as f:
                session_data = f"{self.token}\n{self.plate}\n{self.email}"
                f.write(session_data)
            return True

    def logout(self):
        self.token = None
        os.remove(os.path.join(STORAGE_LOCATION, self.session_filename))


def upload_image(image_filename):
    files = [("image", open(image_filename, "rb"))]
    r = requests.post(url="https://meraf.pythonanywhere.com/", files=files)
    print(r.status_code)
    if r.status_code == 200:
        print(r.json()["filename"])
        return "https://meraf.pythonanywhere.com/" + r.json()["filename"]


def on_incident(image_filename, location, plate):
    # Incident handling logic goes here

    requests.post(
        API_URL + f"vehicles/{plate}/incidents/",
        json={"imageUrl": upload_image(image_filename), "location": location},
        headers={"Authorization": f"Bearer {auth.token}"},
    )


# test@gmail.com
@sio.event
def connect():
    print("I'm connected!")


@sio.event
def connect_error(data):
    print("The connection failed!")


@sio.event
def disconnect():
    print("I'm disconnected!")


@sio.on("unlock")
def unlock(data):
    if data == auth.plate:
        vehicle.unlock()
        print("Vehicle unlocked")


@sio.on("lock")
def lock(data):
    if data == auth.plate:
        vehicle.lock()
        print("Vehicle locked")


def location_mainloop():
    location = Location()

    while True:
        try:
            sio.emit(
                "vehicle_status",
                {
                    "latitude": location.latitude,
                    "longitude": location.longitude,
                    "plate": auth.plate,
                    "email": auth.email,
                    "locked": vehicle.locked,
                },
            )
            sio.sleep(1)

        except KeyboardInterrupt:
            break

        except Exception as e:
            print(e)

    sio.disconnect()


def incident_loop():
    while True:
        try:
            filename = input("Press enter to report an incident file location")
            on_incident(filename, "123 456", auth.plate)
            sio.emit("vehicle_incident", {"plate": auth.plate})
            sio.sleep(5)

        except KeyboardInterrupt:
            break

        except Exception as e:
            print(e)


if __name__ == "__main__":

    os.makedirs(STORAGE_LOCATION, exist_ok=True)

    auth = Auth()

    vehicle = VehicleState()

    while not auth.is_logged_in:
        print("Login to continue")

        email = input("Enter your email: ")
        password = getpass("Enter your password: ")
        plate = input("Enter your vehicle plate: ")

        if not auth.login(email, password, plate):
            print("Invalid email or password. Please try again.")

        print()

    sio.connect(API_URL, headers={"authorization": f"{auth.token}"})

    threading.Thread(target=location_mainloop).start()

    incident_loop()
