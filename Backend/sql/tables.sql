CREATE TABLE providers(
   provider_id INT AUTO_INCREMENT PRIMARY KEY,
   first_name VARCHAR(100) NOT NULL,
   last_name VARCHAR(150) NOT NULL,
   phone_number VARCHAR(150),
   longitude DOUBLE NOT NULL,
   latitude DOUBLE NOT NULL,
   device_token CHAR(64) NOT NULL
);

CREATE TABLE responders(
   provider_id INT NOT NULL,
   incident_id INT NOT NULL
);

CREATE TABLE incidents(
   incident_id INT AUTO_INCREMENT PRIMARY KEY,
   dispatch_id INT NOT NULL,
   longitude DOUBLE NOT NULL,
   latitude DOUBLE NOT NULL,
   recorded TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE dispatchers(
   dispatcher_id INT AUTO_INCREMENT PRIMARY KEY,
   longitude DOUBLE NOT NULL,
   latitude DOUBLE NOT NULL,
   dispatch_name VARCHAR(200),
   member_since DATETIME NOT NULL
);
