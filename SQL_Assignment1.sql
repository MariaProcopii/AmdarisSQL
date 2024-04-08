CREATE TABLE VehicleTypes (
    id UUID PRIMARY KEY,
    car_model VARCHAR(255) NOT NULL
);

CREATE TABLE drivers (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    license_number VARCHAR(50) NOT NULL,
    vehicle_type_id UUID REFERENCES VehicleTypes(id)
);

CREATE TABLE passengers (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE PaymentMethods (
    id UUID PRIMARY KEY,
    payment_method VARCHAR(255) NOT NULL
);

CREATE TABLE passenger_payments (
    passenger_id UUID REFERENCES passengers(id),
    payment_method_id UUID REFERENCES PaymentMethods(id),
    PRIMARY KEY (passenger_id, payment_method_id)
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
