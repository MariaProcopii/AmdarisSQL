CREATE TABLE drivers (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE vehicles (
    driver_id UUID PRIMARY KEY REFERENCES drivers(id),
    car_model VARCHAR(255) NOT NULL,
    license_number VARCHAR(50) NOT NULL
);

CREATE TABLE passengers (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE passenger_payments (
    passenger_id UUID PRIMARY KEY REFERENCES passengers(id),
    payment_method VARCHAR(255) NOT NULL
);

CREATE TABLE rides (
    id UUID PRIMARY KEY,
    date_of_ride TIMESTAMP NOT NULL,
    destination_from VARCHAR(255) NOT NULL,
    destination_to VARCHAR(255) NOT NULL,
    available_seats INTEGER NOT NULL,
    owner_id UUID REFERENCES drivers(id) ON DELETE CASCADE
);

CREATE TABLE ride_passengers (
    ride_id UUID REFERENCES rides(id) ON DELETE CASCADE,
    passenger_id UUID REFERENCES passengers(id) ON DELETE CASCADE,
    PRIMARY KEY (ride_id, passenger_id)
);