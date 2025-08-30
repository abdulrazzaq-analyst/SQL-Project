CREATE TABLE departments (
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    head_of_department_id VARCHAR(10)
);

CREATE TABLE doctors (
    doctor_id VARCHAR(10) PRIMARY KEY,
    nic VARCHAR(15) NOT NULL UNIQUE,
    name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(8) CHECK (gender IN ('Male', 'Female')),
    phone_number VARCHAR(13),
    email VARCHAR(100) UNIQUE,
    address TEXT,
    year_experience INT,
    specialization VARCHAR(100),
    department_id VARCHAR(10),
    salary NUMERIC(10,2),
    joining_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

ALTER TABLE departments
ADD FOREIGN KEY (head_of_department_id) REFERENCES doctors(doctor_id);

CREATE TABLE patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(8) CHECK (gender IN ('Male','Female')),
    phone_number VARCHAR(13),
    blood_group VARCHAR(4) CHECK (blood_group IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    emergency_contact VARCHAR(13),
    address TEXT,
    registered_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    doctor_id VARCHAR(10) NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME,
    reason_for_visit TEXT,
    status VARCHAR(20) CHECK (status IN ('Scheduled','Completed','No-show','Cancelled')),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE treatments (
    treatment_id VARCHAR(10) PRIMARY KEY,
    treatment_name VARCHAR(100) NOT NULL,
    appointment_id VARCHAR(10) NOT NULL,
    description TEXT,
    cost NUMERIC(10,2),
    treatment_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

CREATE TABLE visit_records (
    visit_id VARCHAR(10) PRIMARY KEY,
    appointment_id VARCHAR(10) NOT NULL,
    patient_id VARCHAR(10) NOT NULL,
    doctor_id VARCHAR(10) NOT NULL,
    symptoms VARCHAR(50),
    disease VARCHAR(50),
    diagnosis VARCHAR(50),
    visit_date DATE,
    next_appointment_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE billing (
    billing_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    treatment_id VARCHAR(10) NOT NULL,
    amount NUMERIC(10,2),
    payment_status VARCHAR(25),
    bill_date DATE,
    due_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id)
);
